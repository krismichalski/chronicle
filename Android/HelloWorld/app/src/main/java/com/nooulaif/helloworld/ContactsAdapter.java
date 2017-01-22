package com.nooulaif.helloworld;

import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import java.util.List;

public class ContactsAdapter extends RecyclerView.Adapter<ContactsAdapter.ViewHolder> {
    private List<Contact> contactList;

    public ContactsAdapter(List<Contact> contactList) {
        this.contactList = contactList;
    }

    @Override
    public ViewHolder onCreateViewHolder(ViewGroup viewGroup, int i) {
        View view = LayoutInflater.from(viewGroup.getContext()).inflate(R.layout.contact_list, null);

        ViewHolder viewHolder = new ViewHolder(view);
        return viewHolder;
    }

    @Override
    public void onBindViewHolder(ViewHolder viewHolder, int i) {
        Contact contact = contactList.get(i);

        viewHolder.textContactName.setText(contact.getFirstName() + " " + contact.getLastName());
        viewHolder.textContactGender.setText(contact.getGender());
        viewHolder.textContactPhone.setText(contact.getPhone());
    }

    @Override
    public int getItemCount() {
        return (null != contactList ? contactList.size() : 0);
    }

    public class ViewHolder extends RecyclerView.ViewHolder {
        // protected ImageView imageView;
        protected TextView textContactName, textContactGender, textContactPhone;

        public ViewHolder(View view) {
            super(view);

            this.textContactName = (TextView) view.findViewById(R.id.textContactName);
            this.textContactGender = (TextView) view.findViewById(R.id.textContactGender);
            this.textContactPhone = (TextView) view.findViewById(R.id.textContactPhone);
        }
    }
}