// Cliente para transferencia de arquivos

// by Jomi Fred Hubner


import java.io.*;
import java.net.*;

public class ClienteArq {
	static final int port = 8181;

	public static void main(String[] args) {
		// primeiro par host, segundo eh o arq
		//
		try {
			Socket socket;
			if (args.length > 1) {
				socket = new Socket(args[0],port);
			} else {
				InetAddress addr = InetAddress.getByName("penha.inf.furb.rct-sc.br"); // pega o ip do servidor
				socket = new Socket(addr,port);
			}
			System.out.println("Socket:" + socket);

			BufferedWriter out = new BufferedWriter(new OutputStreamWriter(socket.getOutputStream()));

			File f = new File(args[1]);
			BufferedReader arqLocal = new BufferedReader(new FileReader(f));

			String s = f.length() + "#";
			out.write( s, 0, s.length() );
			System.out.println("mandando arq de tam "+s);

			int c = arqLocal.read();
			while ( c != -1 ) {
				out.write( c );
				//System.out.print( (char) c);
				c = arqLocal.read();
			}

			System.out.println("\n Fim \n");

			out.close();
			socket.close();

		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}