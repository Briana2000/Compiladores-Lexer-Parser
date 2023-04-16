package ParserLexer;
import java.util.HashMap;

public class SymbolTable {
    private HashMap<String, Object> symbols;
    private SymbolTable parentTable;

    public SymbolTable(SymbolTable parentTable) {
        this.symbols = new HashMap<String, Object>();
        this.parentTable = parentTable;
    }

    public void put(String key, Object value) {
        symbols.put(key, value);
    }

    public Object get(String key) {
        //System.out.println(key);
        Object value = symbols.get(key);

        if (value == null && parentTable != null) {
            value = parentTable.get(key);
        }
        return value;
    }
}

