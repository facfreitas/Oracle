import java.awt.*;
import java.net.*;
import java.io.*;
import java.awt.event.*;

public class Chat extends Frame implements ActionListener
{

	private TextArea output;
	private Button conectar, enviar, aguardar;
	private TextField servidor, usuario, mensagem;
	private Panel texto, campos, botoes, msg, central;
	private ServerSocket Servidor;
	private Socket Cliente;
	private PrintStream Saida;
	private DataInputStream Entrada;

	public Chat()
	{
		super("JavaChat Daniel Ribeiro");
		setSize(450,490);
		setBackground(new Color(0xFFC0C0C0));
		texto = new Panel();
		msg = new Panel();
		central = new Panel();
		campos = new Panel();
		botoes = new Panel();

		output = new TextArea(24,55);
		texto.add(output);
		add(texto,BorderLayout.NORTH);
		
		conectar = new Button("Conectar");
		enviar = new Button("Enviar");
		aguardar = new Button("Aguardar");

		conectar.addActionListener(this);
		enviar.addActionListener(this);
		aguardar.addActionListener(this);
		botoes.add(conectar);
		botoes.add(enviar);
		botoes.add(aguardar);

		botoes.setLayout(new GridLayout(1,1));
		add(botoes,BorderLayout.SOUTH);
		central.setLayout(new GridLayout(2,1));
		add(central,BorderLayout.CENTER);
		msg.setLayout(new GridLayout(1,1));
		central.add(msg,BorderLayout.NORTH);
		campos.setLayout(new GridLayout(1,4));
		central.add(campos,BorderLayout.SOUTH);

		usuario = new TextField(20);
		servidor = new TextField(20);
		mensagem = new TextField(60);

		campos.add (new Label(" Usuario "));
		campos.add (servidor);
		campos.add (new Label(" Apelido "));
		campos.add (usuario);
		msg.add (new Label(" Mensagem "));
		msg.add(mensagem);

		setVisible(true);
	}

	private void readText()
	{
		String buf;
		int teste;

		try
		{
			teste = Entrada.available();
			while (teste!=0)
			{
				buf = new String(Entrada.readLine() + "\n");
				output.appendText(buf);
				teste = Entrada.available();
			}
		}
		catch (IOException e)
		{
			output.appendText(e.toString() + "\n");
			output.appendText(e.getMessage() + "\n");
			return;
		}
	}

	public boolean handleEvent(Event e)
	{
		if(e.id == Event.WINDOW_DESTROY);
			System.exit(0);
		return super.handleEvent(e);
	}

	public void actionPerformed(ActionEvent e)
	{
		if (e.getSource() == conectar)
			conexao();
		if(e.getSource() == enviar)
			envio();
		if(e.getSource() == aguardar)
			aguardando();
	}

	public void aguardando()
	{
		try
		{
			Servidor = new ServerSocket(3000);
			Cliente = Servidor.accept();

			Entrada = new DataInputStream(Cliente.getInputStream());
			Saida = new PrintStream(Cliente.getOutputStream());
		}
		catch (Exception e)
		{
			output.appendText(e.toString() + "\n");
			output.appendText(e.getMessage() + "\n");
			return;
		}
	}

	public void envio()
	{
		try
		{
			output.appendText(usuario.getText() + ">" + mensagem.getText() + "\n");
			Saida.println(usuario.getText() + ">" + mensagem.getText());

		}
		catch (Exception e)
		{
			output.appendText(e.toString() + "\n");
			output.appendText(e.getMessage() + "\n");
			return;
		}
	}

	public void conexao()
	{
		try
		{
			Cliente = new Socket(servidor.getText(),3000);
			Entrada = new DataInputStream(Cliente.getInputStream());
			Saida = new PrintStream(Cliente.getOutputStream());
		}
		catch (Exception e)
		{
			output.appendText(e.toString() + "\n");
			output.appendText(e.getMessage() + "\n");
			return;
		}
	}

	public static void main()
	{
		Chat fc = new Chat();
		while (true)
		{
			if(fc.Entrada!=null);
				fc.readText();
		}
	}	
};