package Puzzle;

import sac.State;
import sac.StateFunction;

public class HManhattan extends StateFunction {
	@Override
	public double calculate(State state) {
		Puzzle p = (Puzzle) state;
        int [] pos;            
        int n = p.board.length;
        for (int i = 1; i < n * n; i++) {
            pos = p.findNumberPosition(i);
            p.manh += Math.abs(pos[0]- Math.floor(i / n)) + Math.abs(pos[1] - (i % n));
        }
		return p.manh;
	}

}
