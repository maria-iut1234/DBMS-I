import java.sql.ResultSet;
import java.sql.Statement;

public class task {

    String sql=null;
    String sql_for_view_balance=null;
    String sql_for_view_transaction_amount=null;
    String sql_for_view_cip=null;
    String sql_for_view_vip=null;
    String sql_for_view_op=null;
    String sql_for_cip=null;
    String sql_for_vip=null;
    String sql_for_op=null;
    String sql_for_neither=null;

    public void task1()
    {
        sql="SELECT COUNT(T_ID) FROM TRANSACTIONS WHERE A_ID=49";
    }

    public void task2()
    {
        sql="SELECT COUNT(T_ID) FROM TRANSACTIONS WHERE TYPE='0'";
    }

    public void task3()
    {
        sql="SELECT * FROM TRANSACTIONS WHERE DTM BETWEEN TO_DATE('2021/06/01 00:00:00', 'yyyy/mm/dd hh24:mi:ss') AND TO_DATE('2022/01/01 00:00:00', 'yyyy/mm/dd hh24:mi:ss')";
    }

    public void task4()
    {
        sql_for_view_balance="create or replace view balance as\n" +
                "select sum(case\n" +
                "            when t.type='0' then amount\n" +
                "            when t.type='1' then -amount\n" +
                "            else 0\n" +
                "            end) as total, a_id\n" +
                "from transactions t\n" +
                "group by a_id";

        sql_for_view_transaction_amount="create or replace view total_amount as\n" +
                "select sum(amount) as sum_amount, a_id\n" +
                "from transactions t\n" +
                "group by a_id";

        sql_for_view_cip="create or replace view total_cip as\n" +
                "select distinct b.a_id\n" +
                "from balance b, total_amount t\n" +
                "where b.total>1000000 and t.sum_amount>5000000";

        sql_for_view_vip="create or replace view total_vip as\n" +
                "select distinct b.a_id\n" +
                "from balance b, total_amount t\n" +
                "where b.total>500000 and b.total<900000 and \n" +
                "t.sum_amount>2500000 and t.sum_amount<4500000";

        sql_for_view_op="create or replace view total_op as\n" +
                "select distinct b.a_id\n" +
                "from balance b, total_amount t\n" +
                "where b.total<100000 and t.sum_amount<1000000";

        sql_for_cip="select count(*) as cip\n" +
                "from total_cip";

        sql_for_vip="select count(*) as vip\n" +
                "from total_vip";

        sql_for_op="select count(*) as op\n" +
                "from total_op";

        sql_for_neither="select count(a_id) as neither\n" +
                "from account\n" +
                "where a_id not in (select a_id from total_vip) and\n" +
                "a_id not in (select a_id from total_cip) and \n" +
                "a_id not in (select a_id from total_op)";
    }
}
