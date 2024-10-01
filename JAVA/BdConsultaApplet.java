// Applet para que consulta enderecos usando CORBA
//
//	by Jomi
//
// Precisa JDK1.2


import BdApp.*;
import org.omg.CosNaming.*;
import org.omg.CosNaming.NamingContextPackage.*;
import org.omg.CORBA.*;
import java.awt.*;

public class BdConsultaApplet 
	extends java.applet.Applet
{

// Atributos

Consulta consultaRef = null; 	// referencia para o objeto remoto de cosulta ao BD

Button	btProcura;
TextField	tfCod;
TextArea	taResult;

// Metodos
//

public void init() {
	// Parte CORBA
	//
	try{
		System.out.print("Inicializando CORBA...");

		// cria e inicializa o ORB
		ORB orb = ORB.init(this, null);

            // obtem o servidor de contexto (mapeia nomes para objetos)
            org.omg.CORBA.Object objRef = orb.resolve_initial_references("NameService");
            NamingContext nContxt = NamingContextHelper.narrow(objRef);
 
            // Obtem a referencia ao objeto servidor de BD
            NameComponent nc = new NameComponent("BdConsulta", "");
            NameComponent path[] = {nc};
            consultaRef = ConsultaHelper.narrow( nContxt.resolve(path) );
		System.out.println("ok.");
    
	} catch(Exception e) {
		taResult.setText("Erro: " + e);
	}	

	// Constroi a Interface
	System.out.print("Construindo a interface...");
	btProcura = new Button("Consulta...");
	tfCod = new TextField(10);
	taResult = new TextArea();

	removeAll();
	setLayout(new BorderLayout());

	Panel p;
	p = new Panel();
	p.setLayout(new FlowLayout());
	p.add(new Label("Digite o código do fornecedor: "));
	p.add(tfCod);
	add("North", p);

	add("Center", taResult);

	p = new Panel();
	p.setLayout(new FlowLayout(FlowLayout.CENTER));
	p.add(btProcura);
	add("South", p);

	/*add("North", tfCod);
	add("Center", taResult);
	add("South", btProcura);*/

	validate();
	show();
	System.out.println("ok.");

} // init


public boolean action(Event e, java.lang.Object arg) {
	if (e.target == btProcura) {
		// chama o metodo do objeto remoto
		if (consultaRef != null) {
			System.out.print("Chamando servidor...");
			String codFornec = tfCod.getText();
			String endereco = consultaRef.getEndereco(codFornec);
			System.out.println("ok.");
			taResult.setText("Endereco do " + codFornec + " é \n" + endereco);

		} else {
			taResult.setText("Não há comunicação estabelecida com o servidor!");
		}
		return true;
	}
	return false;
}


} // classe
