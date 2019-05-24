package cup.example;
import java.util.*;

import java.util.HashMap;
import java.util.Iterator;
public class TablaSimbolos{
HashMap t;
public TablaSimbolos(){
t = new HashMap();
}
public Simbolo insertar(String nombre, String tipo, String valor){
Simbolo s = new Simbolo(nombre,tipo, valor);
t.put(nombre, s);
return s;
}
public Simbolo buscar(String nombre){
return (Simbolo)(t.get(nombre));
}

public Simbolo replace(String nombre, Simbolo sym){
return (Simbolo)(t.replace(nombre, sym));
}

public void imprimir(){
Iterator it = t.values().iterator();
while(it.hasNext()){
Simbolo s = (Simbolo)it.next();
System.out.println(s.tipo +" " +s.nombre + ": "+ s.valor);
}
}
}