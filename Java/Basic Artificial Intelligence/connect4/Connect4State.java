package kmichalski.si.connect4;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Scanner;

import sac.game.AlphaBetaPruning;
import sac.game.GameSearchAlgorithm;
import sac.game.GameState;
import sac.game.GameStateImpl;

public class Connect4State extends GameStateImpl {

	public final int rows = 8;
	public final int columns = 8;
	public byte[][] board = null;
	public final byte O = 2, X = 1, E = 0; // O - computer, X - player
	public byte turn = X;
	public byte top_row_first_made_by = E;
	
	public static void main(String[] args) {
		Connect4State game = new Connect4State();
		
		GameSearchAlgorithm a = new AlphaBetaPruning(game);
		HHeurestic heure = new HHeurestic();
		Connect4State.setHFunction(heure);
		Scanner input = new Scanner(System.in);
		double heurevalue = 0;
		
		System.out.println(game);
		System.out.print("Enter column: ");
		String inputString = input.nextLine();
		game.makeMove(Integer.parseInt(inputString));
		
		while(heurevalue != Double.POSITIVE_INFINITY && heurevalue != Double.NEGATIVE_INFINITY) 		
		{
			a.execute();
			System.out.println("scores: " + a.getMovesScores());
			game.makeMove(Integer.parseInt(a.getFirstBestMove()));
			heurevalue = heure.calculate(game);
		
			if(heurevalue != Double.POSITIVE_INFINITY && heurevalue != Double.NEGATIVE_INFINITY)
			{
				System.out.println(game);
				boolean legalmove = false; 
				while(!legalmove) {
					System.out.print("Enter column: ");
					String inputString1 = input.nextLine();
					legalmove = game.makeMove(Integer.parseInt(inputString1));
				}
				heurevalue = heure.calculate(game);
			}
			
			heurevalue = game.check_for_last_row(heurevalue);
		}
		input.close();
		
		System.out.println(game);
		if(heurevalue == Double.POSITIVE_INFINITY) System.out.println("Computer win!");
		else if(heurevalue == Double.NEGATIVE_INFINITY) System.out.println("Player win!");
	}

	@Override
	public List<GameState> generateChildren() {
		List<GameState> children = new ArrayList<GameState>();
		
		for (int i = 0; i < columns; i++) {
			Connect4State child = new Connect4State(this);
			
			if(child.makeMove(i))
			{
				child.setMoveName(Integer.toString(i));
				children.add(child);
			}
		}
		
		return children;
	}

	public Connect4State()
	{
		board = new byte[rows][columns];
		
		for (int i = 0; i < rows; i++) {
			for (int j = 0; j < columns; j++)
			{
				board[i][j] = E;
			}
		}
	}
		
	public Connect4State(Connect4State parent)
	{
		board = new byte[rows][columns];
		for (int i = 0; i < rows; i++)
			for (int j = 0; j < columns; j++)
				board[i][j] = parent.board[i][j];
		turn = parent.turn;
	}
	
	public String toString() {
		StringBuilder result = new StringBuilder();
		
		for (int i = 0; i < rows; i++)
		{
			for (int j = 0; j < columns; j++)
			{
				result.append(board[i][j]);
				result.append(" ");
			}
			result.append("\n");
		}
		return result.toString();
	}
	
	public double check_for_last_row(double heurevalue) {
		if(top_row_first_made_by != E) {
			if(top_row_first_made_by == O && heurevalue != Double.POSITIVE_INFINITY) {
				heurevalue = Double.NEGATIVE_INFINITY;
			}
			if(top_row_first_made_by == X && heurevalue != Double.NEGATIVE_INFINITY) {
				heurevalue = Double.POSITIVE_INFINITY;
			}
		}
		return heurevalue;
	}
	
    public boolean makeMove(int column)
    {
        for (int i = rows - 1; i >= 0; i--) {
            if (board[i][column] == E) {
                board[i][column] = turn;
                
                if(i == 0) {
                	top_row_first_made_by = turn;
                }
                
                playersSwitch();
                return true;
            }
        }
        return false;
    }
    
	public int hashCode() {
		byte[] linear = new byte [rows*columns];
		int k = 0;
		for (int i = 0; i < rows; i++)
		{
			for (int j = 0; j < columns; j++)
				linear[k++] = board[i][j];
		}
		return Arrays.hashCode(linear);
	}
	
    public void playersSwitch() {
        if(turn == O) {
        	turn = X;
        	setMaximizingTurnNow(false);
        }
        else {
        	turn = O;
        	setMaximizingTurnNow(true);
        }
    }
}
