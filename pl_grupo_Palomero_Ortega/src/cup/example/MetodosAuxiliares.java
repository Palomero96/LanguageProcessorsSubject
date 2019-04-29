package cup.example;
import java.lang.*;


public class MetodosAuxiliares {
	public static void main(String[] args) throws Exception {
		
	}

	//Metodo para convertir un string que es un numero octal a double
	public static double Octalconverter(String val) {
		double valor=0;
		int exponente=0;
		for(int i=val.length()-1; i>0; i--) {

			valor=valor+Character.getNumericValue(val.charAt(i-1)) * Math.pow(8, exponente);
			exponente++;
		}
		return valor;
	}
	
}
