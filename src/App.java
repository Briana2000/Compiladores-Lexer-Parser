import java.nio.file.Files;
import java.nio.file.Paths;

public class App {
    private static String basePath = System.getProperty("user.dir");
    private static String fullPathLexer = basePath + "\\src\\ParserLexer\\yylex.jflex";
    private static String fullPathParser = basePath + "\\src\\ParserLexer\\parser.cup";

    public static void GenerarLexerParser() throws Exception {
        MainJflexCup main = new MainJflexCup();

        // Eliminar archivos antiguos
        Files.deleteIfExists(Paths.get(basePath + "\\src\\ParserLexer\\sym.java"));
        Files.deleteIfExists(Paths.get(basePath + "\\src\\ParserLexer\\Lexer.java"));
        Files.deleteIfExists(Paths.get(basePath + "\\src\\ParserLexer\\parser.java"));

        // Crear archivos nuevos
        main.initLexerParser(fullPathLexer, fullPathParser);

        // Mueve los archivos generados a la carpeta src
        Files.move(Paths.get(basePath + "\\sym.java"), Paths.get(basePath + "\\src\\ParserLexer\\sym.java"));
        Files.move(Paths.get(basePath + "\\parser.java"), Paths.get(basePath + "\\src\\ParserLexer\\parser.java"));
    }

    public static void PruebasLexerParser() throws Exception {
        MainJflexCup main = new MainJflexCup();

        // Pruebas
        main.lexerTest(basePath + "\\src\\Pruebas\\prueba2.txt");
        main.parserTest(basePath + "\\src\\Pruebas\\prueba2.txt");
    }

    public static void main(String[] args) throws Exception{
        GenerarLexerParser();
        PruebasLexerParser();
    }
}
