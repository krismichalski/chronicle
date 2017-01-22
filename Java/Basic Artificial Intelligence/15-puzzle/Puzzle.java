package kmichalski.si.Puzzle;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Random;

import sac.State;
import sac.StateFunction;
import sac.graph.AStar;
import sac.graph.GraphSearchAlgorithm;
import sac.graph.GraphSearchConfigurator;
import sac.graph.GraphState;
import sac.graph.GraphStateImpl;

public class Puzzle extends GraphStateImpl {
	
	Random r = new Random();
	public static final int n=3;
	public static int count=1000;
	public static byte m=0;
	public byte [][] board=null;
	public byte [] position={0,0};
	public int [] tmppos={0,0};
	double manh = 0.0;
	int miss = 0;
	
	public Puzzle()
	{
		board=new byte[n][n];
		
		for (int i=0; i<n; i++)
			for (int j=0; j<n; j++)
			{
				board[i][j]=m;
				m++;
			}
	}
	
	public boolean MoveLeft()
	{
		if (position[1] == 0)
		return false;
		
		byte tmp = board[position[0]][position[1]];
		board[position[0]][position[1]] = board[position[0]][position[1] - 1];
		board[position[0]][position[1] - 1] = tmp;
		position[1]--;
		return true;
	
	}
	
	public boolean MoveUp()
	{
		if (position[0] == 0)
			return false;
		byte tmp = board[position[0]][position[1]];
		board[position[0]][position[1]] = board[position[0] - 1][position[1]];
		board[position[0] - 1][position[1]] = tmp;
		position[0]--;
		return true;
	
	}
	public boolean MoveRight()
	{
		if (position[1] == n - 1)
			return false;
		byte tmp = board[position[0]][position[1]];
		board[position[0]][position[1]] = board[position[0]][position[1] + 1];
		board[position[0]][position[1] + 1] = tmp;
		position[1]++;
		return true;
	
	}
	public boolean MoveDown()
	{
		if (position[0] ==n - 1)
			return false;
		byte tmp = board[position[0]][position[1]];
		board[position[0]][position[1]] = board[position[0] + 1][position[1]];
		board[position[0] + 1][position[1]] = tmp;
		position[0]++;
		return true;
	
	}
	
	
	public void shuffle(int count)
	{
		
		while(count!=0)
		{
			int direction = r.nextInt(4)+1;
			switch (direction)
			{
				case 1 :
					if (MoveLeft()) count--;
					break;
			
				case 2 :
					if (MoveUp()) count--;
					break;
			
					
				case 3:
					if (MoveRight()) count--;
					break;
			
				case 4:
					if (MoveDown()) count--;
					break;
			
			}
			
		}
	}
	

    public int [] findNumberPosition(int number)
    {
        for (int row = 0; row < n; row++) {
            for (int column = 0; column < n; column++) {
                if (board[row][column] == number) {
                    tmppos[0] = row;
                    tmppos[1] = column;
                    
                }
            }
        }
		return tmppos;
    }
	
	public Puzzle(Puzzle parent)
	{
		board=new byte[n][n];
		for (int i=0; i<n; i++)
			for (int j=0; j<n; j++)
				board[i][j]=parent.board[i][j];
		position[0]=parent.position[0];
		position[1]=parent.position[1];
		miss=parent.miss;
	}
	
	
	public int hashCode() {
		byte[] linear = new byte [n*n];
		int k =0;
		for (int i = 0;i<n;i++)
		{
			for (int j = 0;j<n;j++)
				linear[k++]=board[i][j];
		}
		
		return Arrays.hashCode(linear);
	}

	public static void main(String[] args)
	{
		Puzzle s=new Puzzle();
		s.shuffle(count);
		System.out.println("Shuffled: ");
		System.out.println(s);
		
		long manhTime = 0;
		int manhClosed = 0;
		int manhOpen = 0;
		int manhSol = 0;
		double manhG = 0;
		
		long missTime = 0;
		int missClosed = 0;
		int missOpen = 0;
		int missSol = 0;
		double missG = 0;
		
		for (int i = 0; i < 100; i++) {
			GraphSearchAlgorithm a= new AStar(s);
			Puzzle.setHFunction(new HManhattan());
			a.execute();
			
			manhTime += a.getDurationTime();
			manhClosed += a.getClosedStatesCount();
			manhOpen += a.getOpenSet().size();
			manhSol += a.getSolutions().size();
			manhG += a.getSolutions().get(0).getG();
		
			if(i == 0)
				System.out.println("Manh path : " + a.getSolutions().get(0).getMovesAlongPath());
			
			Puzzle.setHFunction(new HMisplacedTiles());
			a.execute();
			
			missTime += a.getDurationTime();
			missClosed += a.getClosedStatesCount();
			missOpen += a.getOpenSet().size();
			missSol += a.getSolutions().size();
			missG += a.getSolutions().get(0).getG();

			if(i == 0)
				System.out.println("Miss path : " + a.getSolutions().get(0).getMovesAlongPath());
		}
	
		System.out.println("");
		
		System.out.println("Manh Avr Time : " + manhTime / 100);
		System.out.println("Manh Avr Closed : " + manhClosed / 100);
		System.out.println("Manh Avr Open : " + manhOpen / 100);
		System.out.println("Manh Avr Solutions : " + manhSol / 100);
		System.out.println("Manh Avr g : " + manhG / 100.0);
		
		System.out.println("");
		
		System.out.println("Miss Avr Time : " + missTime / 100);
		System.out.println("Miss Avr Closed : " + missClosed / 100);
		System.out.println("Miss Avr Open : " + missOpen / 100);
		System.out.println("Miss Avr Solutions : " + missSol / 100);
		System.out.println("Miss Avr g : " + missG / 100.0);
	}
	
	public String toString() {
		StringBuilder  result = new StringBuilder();
		
		for (int i=0; i<n; i++)
		{
			for (int j=0; j<n; j++)
				{
				result.append(board[i][j]);
				result.append(" ");
				}
		result.append("\n");
		}
		return result.toString();
	}

	public void fromStringN3(String txt)
	{
		int k=0;
		for (int i=0; i<n; i++)
		{
			for (int j=0; j<n; j++)
			{
				board[i][j]=Byte.valueOf(txt.substring(k,k+1));
		k++;
			}
		}
	} 

	public List<GraphState> generateChildren() {

		List<GraphState> children = new ArrayList<GraphState>();
		
		for(int i=0;i<4;i++)
		{
			Puzzle child = new Puzzle(this);
			boolean changed=false;
			switch (i)
			{
			
			case 0:
				changed = child.MoveLeft();
				child.setMoveName("L");
				break;
			case 1:
				changed = child.MoveUp();
				child.setMoveName("U");
				break;
			case 2: 
				changed = child.MoveRight();
				child.setMoveName("R");
				break;
			case 3: 
				changed = child.MoveDown();
				child.setMoveName("D");
				break;
			}
		
			if(changed)
			{
				
				children.add(child);
			}
		}
		return children;
	}

	public boolean isSolution() {
		int tmp=0;
		for(int i=0;i<n;i++)
			for(int j=0;j<n;j++,tmp++)
				if(board[i][j]!=tmp)
					return false;
		return true;
	}
}