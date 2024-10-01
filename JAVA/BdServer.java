// Servidor ORB para que consulta enderecos
//
//	by Jomi
//
// Precisa JDK1.2



import java.sql.*;
import BdApp.*;
import org.omg.CosNaming.*;
import org.omg.CosNaming.NamingContextPackage.*;
import org.omg.CORBA.*;

class BdServant extends _ConsultaImplBase
{
    Connection conn;
    Statement stmt;

    public BdServant() {
	System.out.print("Iniciando Servant e Conectando com o BD...");

	try {
		conn = DriverManager.getConnection ("jdbc:odbc:teste", "", "");
		stmt = conn.createStatement ();

		System.out.println("ok.");
	} catch (Exception e) {
		System.out.println("Erro no acesso ao BD \n" + e);
	}
    }

    // O metodo que eh chamado remotamente
    // 
    public String getEndereco(String cod)
    {
	System.out.print("Servant Bd Consulta respondendo a consulta pelo cod "+cod);
	// acessa o BD
	try {
		ResultSet rset = stmt.executeQuery ("select Endereco, Cidade, Regiao, CEP from FORNECB where cod = "+ cod);

		if (rset.next ()) {
			return rset.getString(1) + "\n" + rset.getString(2) + ", " + rset.getString(3) + "\n" + rset.getString(4) + ".";
		} else {
			return "Nao existe o codigo " + cod + "!";
		}
	} catch (Exception e) {
		return "Erro no acesso ao BD \n" + e;
	}
    }
}



public class BdServer {
    public static void main(String args[])
    {
	try{
		System.out.println("Server iniciando....");
		Class.forName("sun.jdbc.odbc.JdbcOdbcDriver");

		ORB orb = ORB.init(args, null);

		BdServant bdRef = new BdServant();
		orb.connect(bdRef);

		org.omg.CORBA.Object objRef = orb.resolve_initial_references("NameService");
		NamingContext ncRef = NamingContextHelper.narrow(objRef);

            // Registra o objeto servidor de BD Consulta no NameService
		NameComponent nc = new NameComponent("BdConsulta", "");
		NameComponent path[] = {nc};
		ncRef.rebind(path, bdRef);

		System.out.println("Server esperando....");

		java.lang.Object sync = new java.lang.Object();
		synchronized (sync) {
			sync.wait();
		}

	} catch (Exception e) {
	    System.err.println("ERROR: " + e);
	    e.printStackTrace(System.out);
	}
    }
}
