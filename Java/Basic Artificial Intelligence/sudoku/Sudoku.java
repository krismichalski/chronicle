package kmichalski.si.sudoku;

import java.util.ArrayList;
import java.util.List;

import sac.State;
import sac.StateFunction;
import sac.graph.BestFirstSearch;
import sac.graph.Dijkstra;
import sac.graph.GraphSearchAlgorithm;
import sac.graph.GraphState;
import sac.graph.GraphStateImpl;

public class Sudoku extends GraphStateImpl {
	public static final int n = 3;
	public static final int n2 = n * n;

	public byte[][] board = null;

	private int unknowns = n2 * n2;

	public Sudoku() {
		board = new byte[n2][n2];

		for (int i = 0; i < n2; i++) {
			for (int j = 0; j < n2; j++) {
				board[i][j] = 0;
			}
		}
	}
	
	public Sudoku(Sudoku parent) {
		board = new byte[n2][n2];

		for (int i = 0; i < n2; i++) {
			for (int j = 0; j < n2; j++) {
				board[i][j] = parent.board[i][j];
			}
		}

		unknowns = parent.unknowns;
	}

	public static void main(String[] args) {
		Sudoku s = new Sudoku();
		String txt = "000125400008400000420800000030000095060902010510000060000003049000007200001298000";

		s.fromStringN3(txt);
		
		if (s.isLegal()) {
			System.out.println(s);
		} else {
			System.out.println("Error!");
		}
		
		GraphSearchAlgorithm a = new BestFirstSearch(s);
		a.execute();
		List<GraphState> solutions = a.getSolutions();
		
		for(GraphState solution : solutions) {
			System.out.println(solution);
		}
	}

	@Override
	public String toString() {
		String result = "";

		for (int i = 0; i < n2; i++) {
			for (int j = 0; j < n2; j++) {
				result += board[i][j];

				if ((j + 1) % n == 0) {
					if ((j + 1) != n2) {
						result += "|";
					}
				} else {
					result += " ";
				}
			}

			if ((i + 1) % n == 0 && (i + 1) != n2) {
				result += "\n";
				for (int j = 0; j < n2 * 2; j++) {
					result += "-";
				}
			}
			result += "\n";
		}

		return result;
	}

	public void fromStringN3(String txt) {
		int k = 0;

		for (int i = 0; i < n2; i++) {
			for (int j = 0; j < n2; j++) {
				board[i][j] = Byte.valueOf(txt.substring(k, k + 1));
				k++;
			}
		}

		countUnknowns();
	}

	public boolean isLegal() {

		byte[] group = new byte[n2];

		// rows
		for (int i = 0; i < group.length; i++) {
			for (int j = 0; j < group.length; j++) {
				group[j] = board[i][j];
			}
			if (!isGroupLegal(group)) {
				return false;
			}
		}
		// columns
		for (int i = 0; i < group.length; i++) {
			for (int j = 0; j < group.length; j++) {
				group[j] = board[j][i];
			}
			if (!isGroupLegal(group)) {
				return false;
			}
		}

		// sub-squares
		for (int i = 0; i < n; i++) {
			for (int j = 0; j < n; j++) {
				int q = 0;

				for (int k = 0; k < n; k++) {
					for (int l = 0; l < n; l++) {
						group[q++] = board[i * n + k][j * n + l];
					}
				}
				if (!isGroupLegal(group)) {
					return false;
				}
			}
		}
		return true;
	}

	private boolean isGroupLegal(byte[] group) {
		boolean[] visited = new boolean[n2];

		for (int i = 0; i < visited.length; i++) {
			visited[i] = false;
		}

		for (int i = 0; i < visited.length; i++) {
			if (group[i] == 0) {
				continue;
			}

			if (visited[group[i] - 1]) {
				return false;
			} else {
				visited[group[i] - 1] = true;
			}
		}

		return true;
	}

	private void countUnknowns() {
		unknowns = 0;

		for (int i = 0; i < n2; i++) {
			for (int j = 0; j < n2; j++) {
				if (board[i][j] == 0) {
					unknowns++;
				}
			}
		}
	}

	@Override
	public List<GraphState> generateChildren() {
		int i = 0, j = 0;

		zerofound: for (i = 0; i < n2; i++) {
			for (j = 0; j < n2; j++) {
				if (board[i][j] == 0) {
					break zerofound;
				}
			}
		}
		
		List<GraphState> children = new ArrayList<GraphState>();
		
		for (int k = 0; k < n2; k++) {
			Sudoku child = new Sudoku(this);
			child.board[i][j] = (byte)(k + 1);
			if (!child.isLegal()) {
				continue;
			}
			child.unknowns--;
			children.add(child);
		}
		
		return children;
	}

	@Override
	public boolean isSolution() {
		return (unknowns == 0) && isLegal();
	}
	
	static {
		setHFunction(new StateFunction() {
			@Override
			public double calculate(State state) {
				return ((Sudoku) state).unknowns;
			}
		});
	}
}
