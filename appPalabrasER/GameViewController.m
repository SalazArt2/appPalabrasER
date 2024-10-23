//
//  GameViewController.m
//  appPalabrasER
//
//  Created by Shalom Isai Salazar Arguijo on 20/10/24.
//

#import "GameViewController.h"

@interface GameViewController ()

@end

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self resetGame];
}
- (void)resetGame {
    NSArray *listaPalabras = @[@"Libro", @"Manos", @"Lapiz", @"Pluma", @"Cielo", @"Huevo",@"Fuego",@"Mundo",@"Silla",@"Jugar",@"Verde",@"Resto",@"Mouse",@"Pasto",@"Hielo",@"Nigga",@"Rusos",@"Chino",@"Negro"];
    NSUInteger indiceAleatorio = arc4random_uniform((uint32_t)listaPalabras.count);
    palabraObjetivo = listaPalabras[indiceAleatorio];
    pista=0;
    letra = 0;
    pos = 29;
    intentos=6;
    restantes=6;
    for(UILabel *label in self.lblResul){
        label.text=@"";
        label.textColor=[UIColor blueColor];
        label.backgroundColor=[UIColor whiteColor];
    }
    for(UIButton *boton in self.botonesLetras){
        boton.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        
    }
}
- (IBAction)btnPonerLetra:(UIButton *)sender {
    if (letra <= 4) {
        UILabel *label = self.lblInput[letra];
        label.text = sender.titleLabel.text;
        letra++;
    }
}

- (IBAction)btnBorrar:(UIButton *)sender {
    if (letra > 0) {
        letra--;
        UILabel *label = self.lblInput[letra];
        label.text = @"";
    }
}

- (IBAction)bntIngresar:(UIButton *)sender {
    NSMutableString *palabraIngresada = [[NSMutableString alloc] init];
    for (UILabel *label in self.lblInput) {
        [palabraIngresada appendString:label.text];
    }
    
    // Verificar la palabra ingresada
    [self verificarPalabra:palabraIngresada];
    
    pos -= 5;
    letra = 0;
}
- (void)verificarPalabra:(NSString *)palabraIngresada {
    int aciertos = 0;
    restantes--;
    NSMutableArray *letrasObjetivoUsadas = [NSMutableArray arrayWithCapacity:palabraObjetivo.length];
    NSMutableArray *letrasBotonColoreadas = [NSMutableArray arrayWithCapacity:self.botonesLetras.count];
    
    // Inicializa el array con valores NO para indicar que ninguna letra ha sido usada
    for (int i = 0; i < palabraObjetivo.length; i++) {
        [letrasObjetivoUsadas addObject:@NO];
    }

    // Inicializa el array para verificar los botones ya coloreados
    for (int i = 0; i < self.botonesLetras.count; i++) {
        [letrasBotonColoreadas addObject:@NO];
    }

    // Primero, marcar letras correctas en su posición correcta (🟩)
    for (int i = 0; i < palabraIngresada.length; i++) {
        NSString *letraIngresada = [palabraIngresada substringWithRange:NSMakeRange(i, 1)];
        UILabel *labelResultado = self.lblResul[pos - i];
        UIButton *botonCorrespondiente = nil;
        
        for (int j = 0; j < self.botonesLetras.count; j++) {
            UIButton *boton = self.botonesLetras[j];
            if ([boton.titleLabel.text isEqualToString:letraIngresada] && ![letrasBotonColoreadas[j] boolValue]) {
                botonCorrespondiente = boton;
                letrasBotonColoreadas[j] = @YES;  // Marca este botón como ya coloreado
                break;
            }
        }
        
        NSString *letraObjetivo = [palabraObjetivo substringWithRange:NSMakeRange(i, 1)];
        if ([[letraIngresada lowercaseString] isEqualToString:[letraObjetivo lowercaseString]]) {
            aciertos++;
            labelResultado.backgroundColor = [UIColor greenColor];
            if (botonCorrespondiente) {
                botonCorrespondiente.backgroundColor = [UIColor greenColor];
                botonCorrespondiente.tintColor=[UIColor blackColor];
            }
            letrasObjetivoUsadas[i] = @YES;  // Marca esta letra como usada
        } else {
            // Inicialmente, marca todo como negro en caso de que no esté en la palabra
            labelResultado.backgroundColor = [UIColor blackColor];
            labelResultado.textColor = [UIColor whiteColor];
            if (botonCorrespondiente && ![botonCorrespondiente.backgroundColor isEqual:[UIColor greenColor]]) {
                botonCorrespondiente.backgroundColor = [UIColor blackColor];
                botonCorrespondiente.tintColor=[UIColor whiteColor];
            }
        }
        labelResultado.text = letraIngresada;
    }

    // Luego, marcar letras que están en la palabra pero en posición incorrecta (🟨)
    for (int i = 0; i < palabraIngresada.length; i++) {
        NSString *letraIngresada = [palabraIngresada substringWithRange:NSMakeRange(i, 1)];
        UILabel *labelResultado = self.lblResul[pos - i];
        UIButton *botonCorrespondiente = nil;

        // Solo cambia si no es verde (es decir, no está en la posición correcta)
        if (![labelResultado.backgroundColor isEqual:[UIColor greenColor]]) {
            for (int j = 0; j < palabraObjetivo.length; j++) {
                NSString *letraObjetivo = [palabraObjetivo substringWithRange:NSMakeRange(j, 1)];

                if (![letrasObjetivoUsadas[j] boolValue] && [[letraIngresada lowercaseString] isEqualToString:[letraObjetivo lowercaseString]]) {
                    labelResultado.backgroundColor = [UIColor yellowColor];
                    labelResultado.textColor = [UIColor blackColor];
                    
                    for (int k = 0; k < self.botonesLetras.count; k++) {
                        UIButton *boton = self.botonesLetras[k];
                        if ([boton.titleLabel.text isEqualToString:letraIngresada] && ![boton.backgroundColor isEqual:[UIColor greenColor]]) {
                            botonCorrespondiente = boton;
                            break;
                        }
                    }
                    
                    if (botonCorrespondiente && ![botonCorrespondiente.backgroundColor isEqual:[UIColor greenColor]]) {
                        botonCorrespondiente.backgroundColor = [UIColor yellowColor];
                        botonCorrespondiente.tintColor=[UIColor blackColor];
                    }
                    
                    letrasObjetivoUsadas[j] = @YES;  // Marca esta letra como usada
                    break;
                }
            }
        }
    }

    // Limpiar las etiquetas de entrada después de ingresar una palabra
    for (int i = 0; i < 5; i++) {
        UILabel *label = self.lblInput[i];
        label.text = @"";
    }

    if (aciertos == 5) {
        NSString *mensaje = @"¿Quieres jugar de nuevo?";
        [self showEndGameAlertWithTitle:@"Ganaste" message:mensaje];
    } else {
        if (restantes == 0) {
            NSString *mensaje = @"¿Quieres intentar de nuevo?";
            [self showEndGameAlertWithTitle:@"Perdiste" message:mensaje];
        }
    }
}


- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:nil];
    
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)showEndGameAlertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    // Acción para Jugar de nuevo
    UIAlertAction *playAgainAction = [UIAlertAction actionWithTitle:@"Jugar de nuevo"
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction * _Nonnull action) {
        [self resetGame];  // Reiniciar el juego
    }];
    
    // Acción para Salir del juego
    UIAlertAction *exitAction = [UIAlertAction actionWithTitle:@"Regresar"
                                                         style:UIAlertActionStyleDestructive
                                                       handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alert addAction:playAgainAction];
    [alert addAction:exitAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}
- (IBAction)btnSalir:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)btnPista:(UIButton *)sender {
    NSError *error = nil;
    NSRegularExpression *regexV = [NSRegularExpression regularExpressionWithPattern:@"[aeiouáéíóúAEIOUÁÉÍÓÚ]" options:0 error:&error];
    NSRegularExpression *regexC = [NSRegularExpression regularExpressionWithPattern:@"[qwrtypsdfghklzxcvbnmQWRTYPSDFGHJKLZXCVBNM]" options:0 error:&error];
    NSUInteger cantidadV = [regexV numberOfMatchesInString:palabraObjetivo options:0 range:NSMakeRange(0, palabraObjetivo.length)];
    NSUInteger cantidadC = [regexC numberOfMatchesInString:palabraObjetivo options:0 range:NSMakeRange(0, palabraObjetivo.length)];
    pista++;
    NSMutableString *message=[NSMutableString stringWithString:@""];
    if(pista>0){
        [message appendFormat:@"La palabra tiene: %li vocales",cantidadV];
    }
    if(pista>1){
        [message appendFormat:@"\nLa palabra tiene: %li consonantes",cantidadC];
    }
    if(pista>2){
        [message appendFormat:@"\nLa palabra empieza con: %@",[palabraObjetivo substringWithRange:NSMakeRange(0, 1)]];
    }
    if(pista>3){
        [message appendFormat:@"\nLa palabra termina con: %@",[palabraObjetivo substringWithRange:NSMakeRange(palabraObjetivo.length-1, 1)]];
    }
    if(pista>4){
        [message appendFormat:@"\n_ _ %@ _ _ ",[palabraObjetivo substringWithRange:NSMakeRange(2, 1)]];
    }
    [self showAlertWithTitle:@"Pista" message:message];
}
@end
