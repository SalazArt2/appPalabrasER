//
//  GameViewController.h
//  appPalabrasER
//
//  Created by Shalom Isai Salazar Arguijo on 20/10/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GameViewController : UIViewController{
    int letra;
    int pos;
    int intentos;
    int restantes;
    int pista;
    NSString *palabraObjetivo;
}

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *botonesLetras;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *lblResul;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *lblInput;
- (IBAction)bntIngresar:(UIButton *)sender;
- (IBAction)btnBorrar:(UIButton *)sender;
- (IBAction)btnPonerLetra:(UIButton *)sender;

@end

NS_ASSUME_NONNULL_END
