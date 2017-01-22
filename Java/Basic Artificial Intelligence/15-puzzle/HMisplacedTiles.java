package Puzzle;

import sac.State;
import sac.StateFunction;

public class HMisplacedTiles extends StateFunction {
	@Override
	public double calculate(State state) {
		Puzzle p = (Puzzle) state;
		 p.miss=0;
		 int n = p.board.length;
		 int tmp = 0;
		 for (int i=0; i < n; i++)
			 for (int j=0; j < n; j++,tmp++)
				 if ((p.board[i][j] > 0) && (p.board[i][j]!=tmp))
					 p.miss++;
		return p.miss;
	}

}
