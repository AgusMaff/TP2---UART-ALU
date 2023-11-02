import tkinter as tk
import serial as ser

# Configurar la conexión serial
puerto_serial = ser.Serial(
    port='/dev/ttyUSB1',
    baudrate=19200,
    bytesize=ser.EIGHTBITS,
    parity=ser.PARITY_NONE,
    stopbits=ser.STOPBITS_ONE,
    timeout=0
)

def enviar_valor(entrada):
    #dato = int(entrada.get()).to_bytes(1,"big")
    #print(f"Valor: {dato}")
    #print(f"Valor: {int(entrada.get())}")
    if int(entrada.get()) > 0:
    # Enviar datos por el puerto serial
    	valor = 2
    	dato = int(valor).to_bytes(1,"big")
    	puerto_serial.write(dato)
    	print(f"se envio {dato}")
    # Cerrar la conexión serial
    #puerto_serial.close()
    
    

codigosOperacion = {
    "+" : 32,
    "-" : 34,
    "&" : 36,
    "|" : 37,
    "^" : 38,
    ">>" : 3,
    ">>>" : 2,
    "!|" : 39
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
