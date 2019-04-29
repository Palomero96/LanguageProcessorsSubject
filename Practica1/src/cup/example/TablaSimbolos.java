package cup.example;
import java.util.*;
import java.util.HashMap;
import java.util.Iterator;
public class TablaSimbolos{
HashMap t;
public TablaSimbolos(){
t = new HashMap();
}
public Simbolo insertar(String nombre){
Simbolo s = new Simbolo(nombre, new Integer(0));
t.put(nombre, s);
return s;
}
public Simbolo buscar(String nombre){
return (Simbolo)(t.get(nombre));
}
public void imprimir(){
Iterator it = t.values().iterator();
while(it.hasNext()){
Simbolo s = (Simbolo)it.next();
System.out.println(s.nombre + ": "+ s.valor);
}
}
}