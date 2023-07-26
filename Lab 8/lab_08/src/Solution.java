import java.sql.*;

public class Solution
{
    static final String JDBC_DRIVER = "oracle.jdbc.driver.OracleDriver";
    static final String DB_URL= "jdbc:oracle:thin:@localhost:1521:xe";
    static final String USER="swe200042172";
    static final String PASS="cse4308";

    public static void main (String args[])
    {
        Connection conn=null;
        Statement stmt=null;
        try
        {
            Class.forName(JDBC_DRIVER);

            System.out.println("Connecting to database");
            conn=DriverManager.getConnection(DB_URL, USER, PASS);

            System.out.println("Creating statement");
            stmt=conn.createStatement();

            String sql;
            sql="SELECT A_ID, AMOUNT, TYPE FROM TRANSACTIONS";

            System.out.println("Executing the query: " + sql);
            ResultSet rs=stmt.executeQuery(sql);
            while(rs.next())
            {
                int account=rs.getInt("a_id");
                int amount=rs.getInt("amount");
                String type=rs.getString("type");
                System.out.print(amount + " taka has been");
                if(type.charAt(0)=='0')
                    System.out.print(" deposited to");
                else
                    System.out.print(" taken out from");
                System.out.println(" account" + account);
            }

            //Lab Task
            task t=new task();

            //Task 1
            t.task1();
            System.out.println("\nExecuting the query for task 1: ");
            rs=stmt.executeQuery(t.sql);
            while(rs.next())
            {
                int count=rs.getInt("count(t_id)");
                System.out.println(count + " transactions have been conducted under account 49.");
            }

            //Task 2
            t.task2();
            System.out.println("\nExecuting the query for task 2: ");
            rs=stmt.executeQuery(t.sql);
            while(rs.next())
            {
                int count=rs.getInt("count(t_id)");
                System.out.println(count + " is the number of total credits.");
            }

            //Task 3
            t.task3();
            System.out.println("\nExecuting the query for task 3:");
            System.out.println("\nList of transactions that occured:");
            rs=stmt.executeQuery(t.sql);
            while(rs.next())
            {
                int t_id=rs.getInt("t_id");
                String dtm=rs.getString("dtm");
                int a_id=rs.getInt("a_id");
                int amount=rs.getInt("amount");
                String type=rs.getString("type");

                System.out.println(t_id + " " + dtm + " " + a_id + " " + amount + " " + type);
            }

            //Task 4
            t.task4();

            System.out.println("\nExecuting the queries for task 4: ");

            stmt.executeQuery(t.sql_for_view_balance);
            stmt.executeQuery(t.sql_for_view_transaction_amount);
            stmt.executeQuery(t.sql_for_view_cip);
            stmt.executeQuery(t.sql_for_view_vip);
            stmt.executeQuery(t.sql_for_view_op);

            rs=stmt.executeQuery(t.sql_for_cip);
            while(rs.next())
            {
                int cip=rs.getInt("cip");
                System.out.println("Number of CIP accounts: " + cip);
            }

            rs=stmt.executeQuery(t.sql_for_vip);
            while(rs.next())
            {
                int vip=rs.getInt("vip");
                System.out.println("Number of VIP accounts: " + vip);
            }

            rs=stmt.executeQuery(t.sql_for_op);
            while(rs.next())
            {
                int op=rs.getInt("op");
                System.out.println("Number of OP accounts: " + op);
            }

            rs=stmt.executeQuery(t.sql_for_neither);
            while(rs.next())
            {
                int n=rs.getInt("neither");
                System.out.println("Number of accounts which are neither CIP, VIP nor OP: " + n);
            }

            rs.close();
            stmt.close();
            conn.close();
        }
        catch(SQLException se)
        {
            se.printStackTrace();
        }
        catch(Exception e)
        {
            e.printStackTrace();
        }
    }
}