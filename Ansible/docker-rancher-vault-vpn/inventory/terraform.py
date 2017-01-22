#!/usr/bin/env python
#
# Copyright 2015 Cisco Systems, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
from __future__ import unicode_literals, print_function
import argparse
from collections import defaultdict
from functools import wraps
import json
import os
import re

VERSION = '0.3.0pre'


def tfstates(root=None):
    root = root or os.getcwd()
    for dirpath, _, filenames in os.walk(root):
        for name in filenames:
            if os.path.splitext(name)[-1] == '.tfstate':
                yield os.path.join(dirpath, name)


def iterresources(filenames):
    for filename in filenames:
        with open(filename, 'r') as json_file:
            state = json.load(json_file)
            for module in state['modules']:
                name = module['path'][-1]
                for key, resource in module['resources'].items():
                    yield name, key, resource

## READ RESOURCES
PARSERS = {}


def _clean_dc(dcname):
    # Consul DCs are strictly alphanumeric with underscores and hyphens -
    # ensure that the consul_dc attribute meets these requirements.
    return re.sub('[^\w_\-]', '-', dcname)


def iterhosts(resources):
    '''yield host tuples of (name, attributes, groups)'''
    for module_name, key, resource in resources:
        resource_type, name = key.split('.', 1)
        try:
            parser = PARSERS[resource_type]
        except KeyError:
            continue

        yield parser(resource, module_name)


def parses(prefix):
    def inner(func):
        PARSERS[prefix] = func
        return func

    return inner


def calculate_mantl_vars(func):
    """calculate Mantl vars"""

    @wraps(func)
    def inner(*args, **kwargs):
        name, attrs, groups = func(*args, **kwargs)

        # attrs
        if attrs.get('role', '') == 'control':
            attrs['consul_is_server'] = True
        else:
            attrs['consul_is_server'] = False

        # groups
        if attrs.get('publicly_routable', False):
            groups.append('publicly_routable')

        return name, attrs, groups

    return inner


def _parse_prefix(source, prefix, sep='.'):
    for compkey, value in source.items():
        try:
            curprefix, rest = compkey.split(sep, 1)
        except ValueError:
            continue

        if curprefix != prefix or rest == '#':
            continue

        yield rest, value


def parse_attr_list(source, prefix, sep='.'):
    attrs = defaultdict(dict)
    for compkey, value in _parse_prefix(source, prefix, sep):
        idx, key = compkey.split(sep, 1)
        attrs[idx][key] = value

    return attrs.values()


def parse_dict(source, prefix, sep='.'):
    return dict(_parse_prefix(source, prefix, sep))


def parse_list(source, prefix, sep='.'):
    return [value for _, value in _parse_prefix(source, prefix, sep)]


def parse_bool(string_form):
    token = string_form.lower()[0]

    if token == 't':
        return True
    elif token == 'f':
        return False
    else:
        raise ValueError('could not convert %r to a bool' % string_form)

@parses('azurerm_virtual_machine')
def azurerm_host(resource, module_name):
    name = resource['primary']['attributes']['name']
    raw_attrs = resource['primary']['attributes']

    groups = []

    attrs = {
        'name': name,
        'location': raw_attrs['location'],
        'ansible_port': 22,
        'resource_group_name': raw_attrs['resource_group_name']
    }

    tags = parse_dict(raw_attrs, 'tags')

    if tags != {}:
        if tags['role'] != "":
            groups.append(tags['role'])
        if 'parent' in tags:
            groups.append(tags['parent'])
        if tags['ip'] != "":
            attrs['ip_address'] = tags['ip']
            attrs['ansible_host'] = tags['ip']

    os_profile = parse_attr_list(raw_attrs, 'os_profile')[0]

    if os_profile != []:
        if os_profile['admin_username'] != "":
            attrs['ansible_user'] = os_profile['admin_username']

    return name, attrs, groups

## QUERY TYPES
def query_host(hosts, target):
    for name, attrs, _ in hosts:
        if name == target:
            return attrs

    return {}


def query_list(hosts):
    groups = defaultdict(dict)
    meta = {}

    for name, attrs, hostgroups in hosts:
        for group in set(hostgroups):
            groups[group].setdefault('hosts', [])
            groups[group]['hosts'].append(name)

        meta[name] = attrs

    groups['_meta'] = {'hostvars': meta}
    return groups


def query_hostfile(hosts):
    out = ['## begin hosts generated by terraform.py ##']
    out.extend(
        '{}\t{}'.format(attrs['ansible_host'].ljust(16), name)
        for name, attrs, _ in hosts
    )

    out.append('## end hosts generated by terraform.py ##')
    return '\n'.join(out)


def main():
    parser = argparse.ArgumentParser(
        __file__, __doc__,
        formatter_class=argparse.ArgumentDefaultsHelpFormatter, )
    modes = parser.add_mutually_exclusive_group(required=True)
    modes.add_argument('--list',
                       action='store_true',
                       help='list all variables')
    modes.add_argument('--host', help='list variables for a single host')
    modes.add_argument('--version',
                       action='store_true',
                       help='print version and exit')
    modes.add_argument('--hostfile',
                       action='store_true',
                       help='print hosts as a /etc/hosts snippet')
    parser.add_argument('--pretty',
                        action='store_true',
                        help='pretty-print output JSON')
    parser.add_argument('--nometa',
                        action='store_true',
                        help='with --list, exclude hostvars')
    default_root = os.environ.get('TERRAFORM_STATE_ROOT',
                                  os.path.abspath(os.path.join(os.path.dirname(__file__),
                                                               '..', 'terraform', )))
    parser.add_argument('--root',
                        default=default_root,
                        help='custom root to search for `.tfstate`s in')

    args = parser.parse_args()

    if args.version:
        print('%s %s' % (__file__, VERSION))
        parser.exit()

    hosts = iterhosts(iterresources(tfstates(args.root)))
    if args.list:
        output = query_list(hosts)
        if args.nometa:
            del output['_meta']
        print(json.dumps(output, indent=4 if args.pretty else None))
    elif args.host:
        output = query_host(hosts, args.host)
        print(json.dumps(output, indent=4 if args.pretty else None))
    elif args.hostfile:
        output = query_hostfile(hosts)
        print(output)

    parser.exit()


if __name__ == '__main__':
    main()
