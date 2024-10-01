import java.io.*;
import java.sql.*;
/**
 * Este exemplo usa um Driver JDBC para se conectar com uma base Oracle,
 * cujo a inst�ncia est� alocada em 128.0.0.0:1521 e 
 * este banco est� denominado mydatabase
 *  
 * @author (Allan) 
 * @version (31.03.2003)
 */
public class Conex�oOracle {
    public static void main (String args[]) {
        System.out.println("Conex�o Oracle via Driver JDBC");
        Connection connection = null;
        try {
            // Carregando o Driver JDBC
            String driverName = "oracle.jdbc.driver.OracleDriver";
            System.out.println("Tentativa de conex�o com o driver: "+driverName);
            Class.forName(driverName);
            // Criando uma nova conex�o com o banco
            String serverName = "127.0.0.1";
            String portNumber = "1521";
            String sid = "mydatabase";
            String url = "jdbc:oracle:thin:@" + serverName + ":" + portNumber + ":" + sid;
            String username = "username";
            String password = "password";
            // exibe informa�es utilizadas para a conex�o
            System.out.println("Par�metros utilizados na conex�o: "+url+" Usu�rio: "+username + " Senha: "+password);
            
            connection = DriverManager.getConnection(url, username, password);
        } catch (ClassNotFoundException e) {
            // N�o foi poss�vel encontrar o Driver JDBC 
            System.out.println("N�o foi poss�vel encontrar o Driver JDBC");
            System.out.println("Fa�a o download em http://otn.oracle.com/software/content.html");
        } catch (SQLException e) {
            // N�o foi poss�vel se conectar a base de dados
            System.out.println("N�o foi poss�vel se conectar a base de dados");
        }
        System.out.println("Tentativa de conex�o finalizada");
    }
}
