package pa;

import java.net.*;
import java.io.*;
public class cliente {
  Socket s;
  public cliente() {
  try {
    s = new Socket("127.0.0.1",1001);
    System.out.println("Conectado.");
    BufferedWriter out = new BufferedWriter(new OutputStreamWriter(s.getOutputStream()));
    out.write("testando socket cliente...");
    out.flush();
    s.close();
  }
  catch (Exception ex) {
  }
  }
  public static void main(String[] args) {
    cliente cliente1 = new cliente();
  }
}