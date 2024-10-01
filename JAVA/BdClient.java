import BdApp.*;
import org.omg.CosNaming.*;
import org.omg.CORBA.*;

public class BdClient 
{
    public static void main(String args[])
    {
	try{
		// cria e inicialisa o ORB
		ORB orb = ORB.init(args, null);

            // obtem o servidor de contexto (mapeia nomes para objetos)
            org.omg.CORBA.Object objRef = orb.resolve_initial_references("NameService");
            NamingContext nContxt = NamingContextHelper.narrow(objRef);
 
            // Obtem o objeto servidor de BD
            NameComponent nc = new NameComponent("BdConsulta", "");
            NameComponent path[] = {nc};
            Consulta consultaRef = ConsultaHelper.narrow( nContxt.resolve(path) );

		// chama o metodo do objeto remoto
		String codFornec = "2";
		String endereco = consultaRef.getEndereco(codFornec);
		System.out.println("Endereco do " + codFornec + " é " + endereco);

	} catch (Exception e) {
	    System.out.println("ERROR : " + e) ;
	    e.printStackTrace(System.out);
	}
    }
}
