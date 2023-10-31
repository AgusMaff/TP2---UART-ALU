import tkinter as tk
import serial 

def enviar_valor(entrada):
    try:
        valor = format(int(entrada.get()),"08b")
    except ValueError:
        valor = codigosOperacion.get(entrada.get(),"00000000")
        
    
    print(f"Valor: {valor}")

codigosOperacion = {
    "+" : "100000",
    "-" : "100010",
    "&" : "100100",
    "|" : "100101",
    "^" : "100110",
    ">>" : "000011",
    ">>>" : "000010",
    "!|" : "100111"
}

# Crear una instancia de la ventana
ventana = tk.Tk()

# Agregar un titulo a la ventana
ventana.title("ALU")

# Modificar el tamaño de la ventana
ventana.geometry("500x300")
ventana.resizable(0,0)

# Agregar etiquetas instructivas
textA = tk.Label(ventana, text="Ingrese el operando A: ").place(x=20,y=0)
textB = tk.Label(ventana, text="Ingrese el operando B: ").place(x=20,y=40)
textOP = tk.Label(ventana, text="Ingrese el codigo de operacion: ").place(x=20,y=80)
textResultado = tk.Label(ventana, text="Resultado: ").place(x=20,y=120)

# Agregar las entradas donde el usuario puede ingresar valores
entradaA = tk.Entry(ventana, bg="white", fg="black")
entradaA.place(x=20,y=20)
entradaB = tk.Entry(ventana, bg="white", fg="black")
entradaB.place(x=20,y=60)
entradaOP = tk.Entry(ventana, bg="white", fg="black")
entradaOP.place(x=20,y=100)

# Agregar botones para cargas las entradas del usuario
botonA = tk.Button(ventana, text="Ingresar", bg="grey", command=lambda: enviar_valor(entradaA))
botonA.place(x=250,y=20)
botonB = tk.Button(ventana, text="Ingresar", bg="grey", command=lambda: enviar_valor(entradaB))
botonB.place(x=250,y=60)
botonOP = tk.Button(ventana, text="Ingresar", bg="grey", command=lambda: enviar_valor(entradaOP))
botonOP.place(x=250,y=100)

ventana.mainloop()