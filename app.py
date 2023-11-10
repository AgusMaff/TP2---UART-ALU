import tkinter as tk
#import time
import serial as ser
import serial.tools.list_ports

# Obtener una lista de todos los puertos seriales disponibles
ports = list(serial.tools.list_ports.comports())
port = ports[0].device

# Configurar la conexión serial
puerto_serial = ser.Serial(
    port=port,
    baudrate=19200,
    bytesize=ser.EIGHTBITS,
    parity=ser.PARITY_NONE,
    stopbits=ser.STOPBITS_ONE,
    timeout=0
)

def enviar_operando_A():
    resultado.delete(0,len(resultado.get()))
    #if data is None:
    data = int(entradaA.get())
    if -128 <= data <= 127:
        puerto_serial.write(data.to_bytes(1, 'big',signed=True))
        #time.sleep(0.05)
        #data = None
    else:
        resultado.insert(0, "No se ingreso un operando valido")

def enviar_operando_B():
    resultado.delete(0,len(resultado.get()))
    #if data is None:
    data = int(entradaB.get())
    if -128 <= data <= 127:
        puerto_serial.write(data.to_bytes(1, 'big',signed=True))
        #time.sleep(0.05)
        #data = None
    else:
        resultado.insert(0, "No se ingreso un operando valido")
    
def enviar_codigo_operacion():
    resultado.delete(0,len(resultado.get()))
    #if data is None:
    data = str(entradaOP.get())
    if data in codigosOperacion:
        puerto_serial.write(int(codigosOperacion[data]).to_bytes(1, 'big',signed=True))
        #time.sleep(0.05)
        #data = None 
        resultado.insert(0, int(from_bytes(puerto_serial.read()), byteorder='big'))	  
    else:
        resultado.insert(0, "No se ingreso un codigo de operacion valido")
            
codigosOperacion = {
    "+" : 0b100000,
    "-" : 0b100010,
    "&" : 0b100100,
    "|" : 0b100101,
    "^" : 0b100110,
    ">>" : 0b000011,
    ">>>" : 0b000010,
    "!|" : 0b100111,
    "R" : 0b000000
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
resultado = tk.Entry(ventana, bg="white", fg="black",width=50)
resultado.place(x=20,y=140)

# Agregar botones para cargas las entradas del usuario
botonA = tk.Button(ventana, text="Ingresar", bg="grey", command=lambda: enviar_operando_A())
botonA.place(x=250,y=20)
botonB = tk.Button(ventana, text="Ingresar", bg="grey", command=lambda: enviar_operando_B())
botonB.place(x=250,y=60)
botonOP = tk.Button(ventana, text="Ingresar", bg="grey", command=lambda: enviar_codigo_operacion())
botonOP.place(x=250,y=100)



ventana.mainloop()
