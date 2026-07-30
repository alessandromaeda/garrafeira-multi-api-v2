package utility;


import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;

public class ArtSoft {

 public static String computeDigest(String username,
                                    String password,
                                    String challenge) throws Exception {

     byte[] bUsr = sha1(username);
     byte[] bPwd = sha1(password);
     byte[] bCha = sha1(challenge);

     // concatena os 3 hashes num buffer de 60 bytes
     byte[] buffer = new byte[60];
     System.arraycopy(bUsr, 0, buffer,  0, 20);
     System.arraycopy(bPwd, 0, buffer, 20, 20);
     System.arraycopy(bCha, 0, buffer, 40, 20);

     // SHA1 final do buffer
     byte[] result = sha1(buffer);

     return toHex(result);
 }

 // ── helpers ──────────────────────────────────────────────

 private static byte[] sha1(String input) throws Exception {
     return sha1(input.getBytes(StandardCharsets.UTF_8));
 }

 private static byte[] sha1(byte[] input) throws Exception {
     return MessageDigest.getInstance("SHA-1").digest(input);
 }

 private static String toHex(byte[] bytes) {
     StringBuilder sb = new StringBuilder();
     for (byte b : bytes)
         sb.append(String.format("%02x", b));
     return sb.toString();
 }

 public static void main(String[] args) throws Exception {
     String result = computeDigest(
         "ART",
         "SOFT",
         "ABCDEFGHIJKLMNOPQRSTUV"
     );
     System.out.println("Resultado : " + result);
     System.out.println("Esperado  : " + "3df25f88790daaea81f968cdc1a21f1565df6432");
     System.out.println("OK        : " + result.equals("3df25f88790daaea81f968cdc1a21f1565df6432"));
 }
}