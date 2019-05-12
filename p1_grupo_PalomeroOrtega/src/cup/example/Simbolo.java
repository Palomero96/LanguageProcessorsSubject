package cup.example;


class Simbolo{
 
String nombre;
String tipo;
String valor;
 
 public Simbolo(String nombre, String tipo, String valor){
 this.nombre = nombre;
 this.tipo =tipo;
 this.valor = valor;
 }

/* Es posible que tengamos que añadir metodos getter y setter*/
public String getNombre() {
		return nombre;
	}

	public void setNombre(String nombre) {
		this.nombre = nombre;
	}

	public String getTipo() {
		return tipo;
	}

	public void setTipo(String tipo) {
		this.tipo = tipo;
	}

	public String getValor() {
		return valor;
	}

	public void setValor(String valor) {
		this.valor = valor;
	}
 }