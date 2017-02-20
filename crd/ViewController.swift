//
//  ViewController.swift
//  crd
//
//  Created by Beyer, Zachary on 11/10/16.
//  Copyright © 2016 zbeyer. All rights reserved.
//

import UIKit

//TODO: ZBEYER—Should move extensions and Color Configuration to its own file

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    /**
     *  Allows UIColor to take a hex color code as its initialization
     */
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}

extension CALayer {
    /**
     *  Allows a veiw's CALayer to apply a gradient border effect
     *  Applies a Bezier Rounded Rect as a shape mask and adds the 
     *  layer to the view layer hierarchy
     */
    func addGradienBorder(colors:Array<Any> = [UIColor.red.cgColor, UIColor.blue.cgColor], width:CGFloat = 1, radius:CGFloat = 0.0) {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame =  CGRect(origin: CGPoint.zero, size: self.bounds.size)
        gradientLayer.startPoint = CGPoint(x:0.0, y:0.0)
        gradientLayer.endPoint = CGPoint(x:1.0, y:1.0)
        gradientLayer.colors = colors
        let shapeLayer = CAShapeLayer()
        shapeLayer.lineWidth = width
        let path = UIBezierPath(roundedRect: self.bounds, cornerRadius:radius)
        path.close()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.black.cgColor
        gradientLayer.mask = shapeLayer
        gradientLayer.cornerRadius = radius
        
        self.addSublayer(gradientLayer)
    }
    
}

/**
 *  Color Configuration for rendering different color styles on card
 */
class TypeColor: NSObject {
    //TODO: ZBEYER REFACTOR!
    public var gradienta:UIColor!   //background gradient color 1
    public var gradientb:UIColor!   //background gradient color 2
    public var mattBacka:UIColor!   //textField background color 1
    public var mattBackb:UIColor!   //textField background color 2
    public var rimColor:UIColor!    //field border Color
    public var textColor:UIColor!   //text color
    
    /**
     *  Applies a gradient effect to the background of a view 
     *  according to the values of the 
     *       gradienta / gradientb values
     */
    public func applyBoarderGradient(view:UIView, cornerRadius:CGFloat = 0.0) {
        
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.startPoint = CGPoint(x:0, y:0)
        gradient.endPoint = CGPoint(x:1, y:1)
        gradient.colors = [rimColor.cgColor, gradienta.cgColor, gradientb.cgColor, gradienta.cgColor, rimColor.cgColor]
        gradient.cornerRadius = cornerRadius
        view.layer.insertSublayer(gradient, at: 0)
    }
    
    /**
     *  Applies a gradient effect to the background of a view
     *  according to the values of the
     *       mattBacka / mattBackb values
     */
    public func applyTextBG(view:UIView, cornerRadius:CGFloat = 0.0) {
        let colora = mattBacka.withAlphaComponent(0.618).cgColor
        let colorb = mattBackb.withAlphaComponent(0.618).cgColor

        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.startPoint = CGPoint(x:0, y:0)
        gradient.endPoint = CGPoint(x:1, y:1)
        gradient.colors = [colorb, colora, colora, colora, colorb]
        gradient.cornerRadius = cornerRadius
        view.layer.insertSublayer(gradient, at: 0)
    }
    
    /**
     *  Returns an instance of the Color Configuration 
     *  using five color shades (rather than directly 
     *  assigning the properties used by the configuration...
     */
    public func newTypeColorFromSclae(c1:UIColor, c2:UIColor, c3:UIColor, c4:UIColor, c5:UIColor) -> TypeColor {
        let t = self.newTypeColor(bga:c4, bgb: c2, matta: c4, mattb: c5, rimc: c5, txtc:c1)
        return t
    }
    
    /**
     *  Returns an instance of the Color Configuration...
     */
    public func newTypeColor(bga:UIColor, bgb:UIColor, matta:UIColor, mattb:UIColor, rimc:UIColor, txtc:UIColor ) -> TypeColor {
        let tc = TypeColor()
        tc.gradienta = bga
        tc.gradientb = bgb
        tc.mattBacka = matta
        tc.mattBackb = mattb
        tc.rimColor = rimc
        tc.textColor = txtc
        return tc
    }
}



class ViewController: UIViewController {
    private var renderedImage: UIImage!
    private var darkTransparent: UIColor = UIColor.init(colorLiteralRed: 0.0, green: 0.0, blue: 0.0, alpha: 0.75)
    private var lightTransparent: UIColor = UIColor.init(colorLiteralRed: 1.0, green: 1.0, blue: 1.0, alpha: 0.90)
//    private var cardFont:font = UIFont.fontNames(forFamilyName: "")
    @IBOutlet var previewImage: UIImageView!
    
    @IBAction func onSaveImage(_ sender: Any) {
        //TODO:ZBEYER Display an alert to confirm the save and notify on success / failure to write the image...
        UIImageWriteToSavedPhotosAlbum(self.renderedImage,  self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil);
    }
    
    func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
        
        //For debugging purposes: I need the path to my image directory
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        print(documentsDirectory);
    }
    
    /**
     *  Helper to build and set a few options for a
     *  background of a text label or view
     */
    func txtBG(f:CGRect, typeColor:TypeColor, cornerRadius:CGFloat = 8.0) -> UIView {
        let bg = UIView(frame:f)
        bg.layer.addGradienBorder(colors: [typeColor.textColor.cgColor,
                                           typeColor.rimColor.cgColor,
                                           typeColor.textColor.cgColor],
                                  width:8.0,
                                  radius:cornerRadius)
        typeColor.applyTextBG(view: bg, cornerRadius:cornerRadius)
        bg.clipsToBounds = true
        return bg
    }
    
    /**
     *  Helper to build and set a few options for a
     *  text label
     */
    func txtLbl(frame:CGRect, typeColor:TypeColor) -> UILabel {
        let txtLabel = UILabel(frame:frame)
        txtLabel.layer.addGradienBorder(colors: [typeColor.rimColor.cgColor,
                                                 typeColor.textColor.cgColor,
                                                 typeColor.rimColor.cgColor],
                                        width:4.0,
                                        radius:frame.height * 0.5)
        txtLabel.font = UIFont(name: "Verdana-Bold", size: 36)
        txtLabel.backgroundColor = UIColor.clear
        txtLabel.textAlignment = .center
        txtLabel.textColor = typeColor.textColor
        txtLabel.shadowColor = typeColor.rimColor
        txtLabel.shadowOffset = CGSize(width:0, height:-2.0)
        txtLabel.layer.cornerRadius = frame.height * 0.5
        txtLabel.clipsToBounds = true;
        
        return txtLabel
    }
    
    /**
     *  Renders a preview of the current card state...
     */
    func updatePreview() {
        self.previewImage.image = nil
        var typC:TypeColor! = ApplicationState.sharedInstance.typeColorForIndex
        if (typC == nil) {
            typC = TypeColor().newTypeColor(bga: UIColor.init(netHex: 0x616161),
                                            bgb: UIColor.init(netHex: 0xE0E0E0),
                                            matta: UIColor.init(netHex: 0x616161),
                                            mattb: UIColor.init(netHex: 0x212121),
                                            rimc: UIColor.init(netHex: 0x212121),
                                            txtc: UIColor.init(netHex: 0xF5F5F5))
            print("\(typC.mattBacka, typC?.mattBackb)")
        }
        
        //300DPI
        //2.48" x 3.46" (Full Bleed of 2.72" x 3.7") at 300DPI
        //Safe text area: 2.24" x 3.22"
        
        let fullFrame = CGRect(x: 0, y: 0, width: 816, height: 1110)    //FULL IMAGE
        //let bleedFrame = CGRect(x: 0, y: 0, width: 744, height: 1038)   //CUT
        //let safeFrame =  CGRect(x: 0, y: 0, width: 672, height: 966)   //DETAIL SAFE
        //12, 24, 36
        //24, 48, 72
        let borderFrame = CGRect(x: 48, y: 48, width: 720, height: 1014)
        let contentFrame = CGRect(x: 72, y: 72, width: 672, height: 966)
        
        //Set up the view and show the scene
        let cardView = UIView(frame: fullFrame)
        cardView.backgroundColor = UIColor.black
        //Attatch the scene view to the live preview...
        
        let borderView = UIView(frame: borderFrame)
        cardView.addSubview(borderView)
        typC?.applyBoarderGradient(view: borderView)
        
        let contentView = UIView(frame: contentFrame)
        cardView.addSubview(contentView)
        contentView.backgroundColor = UIColor.white
        
        //Set Portrait Image
        if let portrait = ApplicationState.sharedInstance.cardImage {
            let portraitView = UIImageView(frame:contentView.bounds)
            portraitView.contentMode = .scaleAspectFill
            portraitView.clipsToBounds = true
            portraitView.image = portrait
            contentView.addSubview(portraitView)
        }
        
        //A Few Constants
        let bubblePadding:CGFloat = 6.0
        let bubbleSize:CGFloat = 48.0
        let titleWidth:CGFloat = contentView.frame.width-bubblePadding*2
        
        if (ApplicationState.sharedInstance.cardTitle != "") {
            let title = ApplicationState.sharedInstance.cardTitle
            let f:CGRect = CGRect(x:bubblePadding, y:bubblePadding, width:titleWidth, height:bubbleSize)
            let bg = self.txtBG(f:f, typeColor:typC!, cornerRadius: f.height * 0.5)

            let titleLabel = txtLbl(frame: bg.bounds, typeColor:typC!)
            titleLabel.text = title
            
            bg.addSubview(titleLabel)
            contentView.addSubview(bg)
        }
        
        
        
        if (ApplicationState.sharedInstance.cardType != "") {
            let type = ApplicationState.sharedInstance.cardType
            let f:CGRect = CGRect(x:bubblePadding, y:contentView.frame.height - bubblePadding - bubbleSize, width:contentView.frame.width - bubblePadding * 2, height:bubbleSize)
            let bg = self.txtBG(f:f, typeColor:typC!, cornerRadius: f.height * 0.5)

            let typeLabel = txtLbl(frame: bg.bounds, typeColor:typC!)
            typeLabel.text = type
            
            bg.addSubview(typeLabel)
            contentView.addSubview(bg)
        }
        
        if (ApplicationState.sharedInstance.cardInfo != "") {
            let info = ApplicationState.sharedInstance.cardInfo
            let bgf:CGRect = CGRect(x:bubblePadding + bubbleSize * 0.5,
                                  y:bubblePadding * 2 + bubbleSize * 9,
                                  width:contentView.frame.width - bubblePadding * 2 - bubbleSize,
                                  height:contentView.frame.height - bubbleSize * 10 - bubblePadding * 4)
            let bg = self.txtBG(f:bgf, typeColor:typC!)
            bg.layer.cornerRadius = 8.0
            typC?.applyTextBG(view: bg, cornerRadius: 8.0)
            bg.layer.addGradienBorder(colors: [(typC?.textColor.cgColor)!,
                                               (typC?.rimColor.cgColor)!,
                                               (typC?.textColor.cgColor)!],
                                      width: 8.0,
                                      radius: bg.layer.cornerRadius)
            bg.layer.addGradienBorder(colors: [(typC?.rimColor.cgColor)!,
                                               (typC?.textColor.cgColor)!,
                                               (typC?.rimColor.cgColor)!],
                                      width: 4.0,
                                      radius: bg.layer.cornerRadius)
            
            let f:CGRect = CGRect(x:bubblePadding,
                                  y:bubblePadding,
                                  width:bgf.width - bubblePadding * 2,
                                  height:bgf.height - bubblePadding * 2)
            let infoView = UITextView(frame:f)
//            infoView.attributedText = true
            infoView.isEditable = false
            infoView.text = info
            infoView.clipsToBounds = true
            infoView.backgroundColor = UIColor.clear
            infoView.textColor = typC?.textColor
            infoView.font = UIFont(name: "Verdana", size: 36)
            
            infoView.textContainer.maximumNumberOfLines = 10;
            
            /**
             *  For some reason, toggling isScrollEnabled is the only way
             *  To prevent the text from being cut-off...
             */
            
            infoView.isScrollEnabled = false;
            infoView.isScrollEnabled = true;

            bg.addSubview(infoView)
            
            contentView.addSubview(bg)
        }
        
        let roundRects:Bool = true
        if (roundRects) {
            borderView.layer.cornerRadius = 4.0
            contentView.layer.cornerRadius = 2.0
        }
        
        contentView.layer.addGradienBorder(colors: [(typC?.rimColor.cgColor)!,
                                                    (typC?.textColor.cgColor)!,
                                                    (typC?.rimColor.cgColor)!],
                                           width: 2.0,
                                           radius: contentView.layer.cornerRadius )
        
        contentView.layer.addGradienBorder(colors: [(typC?.textColor.cgColor)!,
                                                    (typC?.rimColor.cgColor)!,
                                                    (typC?.textColor.cgColor)!],
                                           width: 1.0,
                                           radius:contentView.layer.cornerRadius )

        
        self.renderedImage = self.renderCardView(cardView: cardView)
        self.previewImage.image = self.renderedImage
    }
    
    func renderCardView(cardView:UIView) -> UIImage {
        UIGraphicsBeginImageContext(cardView.frame.size)
        cardView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updatePreview()
    }
    
}

