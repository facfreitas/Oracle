import java.io.*;
import java.sql.*;
/**
 * Este exemplo usa um Driver JDBC para se conectar com uma base Oracle,
 * cujo a instância está alocada em 128.0.0.0:1521 e 
 * este banco está denominado mydatabase
 *  
 * @author (Allan) 
 * @version (31.03.2003)
 */
public class ConexãoOracle {
    public static void main (String args[]) {
        System.out.println("Conexão Oracle via Driver JDBC");
        Connection connection = null;
        try {
            // Carregando o Driver JDBC
            String driverName = "oracle.jdbc.driver.OracleDriver";
            System.out.println("Tentativa de conexão com o driver: "+driverName);
            Class.forName(driverName);
            // Criando uma nova conexão com o banco
            String serverName = "127.0.0.1";
            String portNumber = "1521";
            String sid = "mydatabase";
            String url = "jdbc:oracle:thin:@" + serverName + ":" + portNumber + ":" + sid;
            String username = "username";
            String password = "password";
            // exibe informaões utilizadas para a conexão
            System.out.println("Parâmetros utilizados na conexão: "+url+" Usuário: "+username + " Senha: "+password);
            
            connection = DriverManager.getConnection(url, username, password);
        } catch (ClassNotFoundException e) {
            // Não foi possível encontrar o Driver JDBC 
            System.out.println("Não foi possível encontrar o Driver JDBC");
            System.out.println("Faça o download em http://otn.oracle.com/software/content.html");
        } catch (SQLException e) {
            // Não foi possível se conectar a base de dados
            System.out.println("Não foi possível se conectar a base de dados");
        }
        System.out.println("Tentativa de conexão finalizada");
    }
}
