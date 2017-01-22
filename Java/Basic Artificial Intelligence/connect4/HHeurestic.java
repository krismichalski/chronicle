package kmichalski.si.connect4;

import sac.State;
import sac.StateFunction;

public class HHeurestic extends StateFunction {
	@Override
	public double calculate(State state) {
		Connect4State connect4 = (Connect4State) state;
		int[] frag = new int[3];
		boolean player;
		double value = 0;
		for (int i = 0; i < connect4.rows; ++i)
		{
			for (int j = 0; j < connect4.columns; ++j)
			{
				if (connect4.board[i][j] == 1) player = true;
				else if (connect4.board[i][j] == 2) player = false;
				else continue;

				if (i >= 3)                                     //UP
				{
					frag[0] = connect4.board[i - 1][j];
					frag[1] = connect4.board[i - 2][j];
					frag[2] = connect4.board[i - 3][j];
					value = calculateFrag(frag, player, value);
				}
				if (i >= 3 && j <= connect4.columns - 4)              //UP RIGHT
				{
					frag[0] = connect4.board[i - 1][j + 1];
					frag[1] = connect4.board[i - 2][j + 2];
					frag[2] = connect4.board[i - 3][j + 3];
					value = calculateFrag(frag, player, value);
				}
				if (j <= connect4.columns - 4)                        //RIGHT
				{
					frag[0] = connect4.board[i][j + 1];
					frag[1] = connect4.board[i][j + 2];
					frag[2] = connect4.board[i][j + 3];
					value = calculateFrag(frag, player, value);
				}
				if (i <= connect4.rows - 4 && j <= connect4.columns - 4)//RIGHT DOWN
				{
					frag[0] = connect4.board[i + 1][j + 1];
					frag[1] = connect4.board[i + 2][j + 2];
					frag[2] = connect4.board[i + 3][j + 3];
					value = calculateFrag(frag, player, value);
				}
				if (i <= connect4.rows - 4)                       //DOWN
				{
					frag[0] = connect4.board[i + 1][j];
					frag[1] = connect4.board[i + 2][j];
					frag[2] = connect4.board[i + 3][j];
					value = calculateFrag(frag, player, value);
				}
				if (i <= connect4.rows - 4 && j >= 3)             //DOWN LEFT
				{
					frag[0] = connect4.board[i + 1][j - 1];
					frag[1] = connect4.board[i + 2][j - 2];
					frag[2] = connect4.board[i + 3][j - 3];
					value = calculateFrag(frag, player, value);
				}
				if (j >= 3)                                     //LEFT
				{
					frag[0] = connect4.board[i][j - 1];
					frag[1] = connect4.board[i][j - 2];
					frag[2] = connect4.board[i][j - 3];
					value = calculateFrag(frag, player, value);
				}
				if (i >= 3 && j >= 3)                           //LEFT UP
				{
					frag[0] = connect4.board[i - 1][j - 1];
					frag[1] = connect4.board[i - 2][j - 2];
					frag[2] = connect4.board[i - 3][j - 3];
					value = calculateFrag(frag, player, value);
				}

				if (value == Double.NEGATIVE_INFINITY || value == Double.POSITIVE_INFINITY) return value;
			}
		}
		
		return value;
	}
	
	private double calculateFrag(int[] frag, boolean player, double value)
	{
		int curval = 1;
		if (!player)
		{
			if (frag[0] == 1 || frag[1] == 1 || frag[2] == 1) { return value; }
			else if (frag[0] == 2 && frag[1] == 2 && frag[2] == 2)
			{
				return Double.POSITIVE_INFINITY;
			}
			else
			{
				for (int z = 0; z < 2; ++z)
				{
					if (frag[z] == 2) curval *= 2;
				}
				return value + curval;
			}
		}
		else
		{
			if (frag[0] == 2 || frag[1] == 2 || frag[2] == 2) { return value; }
			else if (frag[0] == 1 && frag[1] == 1 && frag[2] == 1)
			{
				return Double.NEGATIVE_INFINITY;
			}
			else
			{
				for (int z = 0; z < 2; ++z)
				{
					if (frag[z] == 2) curval *= 2;
				}
				return value - curval;
			}
		}

	}
}
