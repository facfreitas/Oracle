import java.sql.*;

public class BufferHitRatio extends Relatorio_Banco
{

	public double BufferHitRatio()
        {
          String BufHitRat="select round(100 * ((a.value+b.value)-c.value)/(a.value+b.value),2)" +
                            "from v$sysstat a, v$sysstat b, v$sysstat c" +
                            "where a.statistic# = 38 and b.statistic# = 39 and c.statistic# = 40";
          stm=null;
          ResultSet BHRRS=stm.executeQuery(BufHitRat);
          return BHRRS.getDouble(1);

	}
}
