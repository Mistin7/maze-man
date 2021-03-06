//
//  Settings.swift
//  Maze-man
//
//  Created by Chekunin Alexey on 13.02.16.
//  Copyright © 2016 Chekunin Alexey. All rights reserved.
//

import SpriteKit

class Settings: SKScene {
    let statsBg = SKSpriteNode()
    let speedIcon = SKSpriteNode(imageNamed: "speed-icon")
    let speedProgressBar = SKSpriteNode(imageNamed: "progressbar-stats")
    var speedProgressBarBg: SKShapeNode?
    let speedImproveButton = SKSpriteNode(imageNamed: "statsButton")
    var speedStatsName = SKLabelNode(text: "Скорость")
    var speedCost = SKLabelNode(fontNamed: "ChalkboardSE-Bold")
    let speedCropNode = SKCropNode() //Для отображения полосы скорости
    var speedLineMask = SKSpriteNode() //Через неё видна полоса скорости
    let statsPrice: [Int] = [15,20,25,35,45,60,75,90,120,150,180,220,260,300,340,380,430,480,540,600] //Сколько стоят уровни соответственно
    
    //MARK: Различная озвучка
    var clickSound: SKAction?
    
    let defaults = UserDefaults.standard
    override func didMove(to view: SKView) {
        //print("settings scene")
        backgroundColor = SKColor(red: 0, green: 0, blue: 0, alpha: 1.0)
        
        //Всё для характеристик
        statsBg.size = CGSize(width: 630, height: 500)
        statsBg.color = UIColor.black
        statsBg.anchorPoint = CGPoint(x: 0.5, y: 1)
        statsBg.position = CGPoint(x: size.width / 2, y: size.height - 200)
        addChild(statsBg)
        
        speedIcon.position = CGPoint(x: -248, y: -70)
        speedIcon.size = CGSize(width: 64, height: 64)
        statsBg.addChild(speedIcon)
        
        let RoundedRectPath = UIBezierPath(roundedRect: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 365, height: 38)), cornerRadius: 4) //Задаём форму закруглёного фона прогрессбара скорости
        speedProgressBarBg = SKShapeNode(path: RoundedRectPath.cgPath, centered:true)
        speedProgressBarBg!.position = CGPoint(x: -20, y: -70)
        speedProgressBarBg!.lineWidth = 0.0
        speedProgressBarBg!.fillColor = UIColor(red: 78.0/255.0, green: 78.0/255.0, blue: 78.0/255.0, alpha: 1.0)
        statsBg.addChild(speedProgressBarBg!)
        
        speedProgressBar.size = CGSize(width: 355, height: 28)
        speedProgressBar.position = CGPoint(x: 0, y: 0)
        
        speedLineMask = SKSpriteNode(color: UIColor.black, size: CGSize(width: speedProgressBar.size.width + 5, height: speedProgressBar.size.height)) //+10 - 2 отступа (не 1 для симметрии)
        speedLineMask.anchorPoint = CGPoint(x: 0.0, y: 0.5)
        //Тут с CGFloat() тутфтология, так как компилятор иначе ругается. Потом исправить на норм
        let countLinesSpeed: CGFloat = CGFloat(defaults.integer(forKey: "speed") / 5) * CGFloat(18) //Сколько полосочек будет показываться, умноженное на 18px (на сколько px двигаем)
        speedLineMask.position = CGPoint(x: -speedProgressBar.size.width * 1.5 - 6 + countLinesSpeed, y: 0) //1 шаг - 18px (зелёная(13px)+отступ справа целиком(5px))
        
        speedCropNode.addChild(speedProgressBar)
        speedCropNode.maskNode = speedLineMask
        speedCropNode.position = CGPoint(x: 0, y: 0)
        speedProgressBarBg!.addChild(speedCropNode)
        
        speedImproveButton.size = CGSize(width: 114, height: 68)
        speedImproveButton.position = CGPoint(x: 232, y: -68)
        statsBg.addChild(speedImproveButton)
        
        speedStatsName.fontColor = UIColor.white
        speedStatsName.fontSize = 28
        speedStatsName.fontName = "Myriad Pro Semibold"
        speedStatsName.position = CGPoint(x: -136, y: -39)
        statsBg.addChild(speedStatsName)
        
        speedCost.text = String(statsPrice[defaults.integer(forKey: "speed") / 5])
        speedCost.fontSize = 26
        speedCost.fontColor = UIColor(colorLiteralRed: 255.0/255.0, green: 186.0/255.0, blue: 0.0/255.0, alpha: 1.0)
        speedCost.position = CGPoint(x: 10, y: -26)
        speedCost.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        speedCost.zPosition = 10
        speedImproveButton.addChild(speedCost)
        
        //print(size)
        
        //Добавляем различную озвучку
        clickSound = SKAction.playSoundFileNamed("sounds/click.mp3", waitForCompletion: false)
    }
    override init(size: CGSize) {
        super.init(size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            switch atPoint(location) {
            case speedImproveButton:
                if defaults.bool(forKey: "sound") {
                    run(clickSound!)
                }
                plusSpeed()
            default: break
            }
        }
    }
    
    //Когда мы покупаем скорость
    func plusSpeed() {
        if defaults.integer(forKey: "speed") < 100 {
            if defaults.integer(forKey: "coins") >= statsPrice[defaults.integer(forKey: "speed") / 5] { //Если хватает монет на улучшение
                defaults.set(defaults.integer(forKey: "coins") - statsPrice[defaults.integer(forKey: "speed") / 5], forKey: "coins") //Вычитаем из памяти потраченные монеты
                defaults.set(defaults.integer(forKey: "speed") + 5, forKey: "speed") //Повышаем в памяти его скорость
                speedLineMask.position.x += 18 //на один шаг (полоску)
                speedCost.text = String(statsPrice[defaults.integer(forKey: "speed") / 5]) //Изменяем стоимость на кнопочке
                
                NotificationCenter.default.post(name: Notification.Name(rawValue: "changed coins count"), object: self) //Чтобы изменилась надпись с ко-вом монет в competitive
            } else { //Если не хватает монет на улучшение
                print("У Вас не хватает", statsPrice[defaults.integer(forKey: "speed") / 5] - defaults.integer(forKey: "coins"), "монет на улучшение")
            }
        }
    }
}
