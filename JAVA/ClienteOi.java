// Cliente do servidor oi
//
// para usar digite
//		java ClienteOi <nome do host onde esta o servidor oi>
//
// by Jomi Fred Hubner


import java.io.*;
import java.net.*;



public class ClienteOi {
	static final int port = 8181;

	public static void main(String[] args) {
		try {
			Socket socket;
			if (args.length == 1) {
				socket = new Socket(args[0],port);
			} else {
				InetAddress addr = InetAddress.getByName("penha.inf.furb.rct-sc.br"); // pega o ip do servidor
				socket = new Socket(addr,port);
			}
			System.out.println("Socket:" + socket);

			BufferedReader in = new BufferedReader(
				new InputStreamReader(socket.getInputStream()));
			PrintWriter out = new PrintWriter(
				new BufferedWriter(
					new OutputStreamWriter(socket.getOutputStream())));

			// Recebe as boas vindas
			String s = in.readLine();
			System.out.println(s);
			
			// interage com o usuario
			BufferedReader teclado = new BufferedReader(
				new InputStreamReader(System.in));
				
			s = teclado.readLine();
			while (! s.toLowerCase().equals("fim")) {
				
				out.println(s); // manda o que o usuario escreveu
				out.flush();
				
				s = in.readLine(); // pega a resposta do servidor
				System.out.println(s); // mostra para o usuario
				
				s = teclado.readLine();
			}
	

			// Termina a conexao
			out.println("fim");
			out.flush();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}