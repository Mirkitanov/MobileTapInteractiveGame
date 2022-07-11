//
//  MainViewController.swift
//  MobileTapInteractive
//
//  Created by Админ on 05.07.2022.
//

import Foundation
import UIKit

class MainViewController: UIViewController {
    
    // MARK:- Properties
    
    /// Флаг, нужно ли показать индикаторы (при запуске интерактивной игры)
    private var shouldToDisplayAllIndicators = true
    
    /// Удаленный URL
    private lazy var streamURL = URL(string: "https://devstreaming-cdn.apple.com/videos/streaming/examples/bipbop_adv_example_hevc/master.m3u8")!
    /// Первый Локальный URL
    private lazy var localFirstURL: URL = {
        let path = Bundle.main.path(forResource: "test", ofType: "mp4")!
        return URL(fileURLWithPath: path)
    }()
    
    /// Второй Локальный URL
    private lazy var localSecondURL: URL = {
        let path = Bundle.main.path(forResource: "Sea", ofType: "mp4")!
        return URL(fileURLWithPath: path)
    }()
    
    /// Сущность для отображения Видео
    lazy var videoPreviewLooper = VideoLooperView()
    
    /// Счетчик Таймера для интерактивной игры
    var counterOfTimerForInteractiveGame = 0
    
    /// Таймер для интерактивной игры
    var timerForInteractiveGame = Timer()
    
    /// Длительность текущего Видео
    var currentVideoDuration: Float = 0
    
    /// Текущее время текущего Видео
    var currentVideoCurrentTime: Float = 0
    
    /// Основной треугольник-кнопка
    lazy var capitalTriangleButtonView = UIView(frame: CGRect(x: (view.frame.width - 100)/2, y: (view.frame.height - 90)/2, width: 100, height: 90))
    
    /// Дополнительный треугольник внутри основного
    let simpleTriangleView = UIView(frame: CGRect(x: 93, y: 0, width: 80, height: 70))
    
    /// Левый толстый индикатор
    lazy var sideViewLeftThickIndicator = UIView(frame: CGRect(x: 0, y: -view.frame.height/4, width: view.frame.height * 1.5, height: view.frame.height * 1.5))
    
    /// Дополнительное наполнение для Левого тонкого индикатора
    lazy var auxiliarySideViewLeftThickIndicator = UIView(frame: CGRect(x: 0, y: -view.frame.height/4, width: view.frame.height * 1.5, height: view.frame.height * 1.5))
    
    /// Левый тонкий индикатор
    lazy var sideViewLeftThinIndicator = UIView(frame: CGRect(x: 6, y: -view.frame.height/4, width: view.frame.height * 1.5, height: view.frame.height * 1.5))
    
    /// Дополнительное наполнение для Левого тонкого индикатора
    lazy var auxiliarySideViewLeftThinIndicator = UIView(frame: CGRect(x: 6, y: -view.frame.height/4, width: view.frame.height * 1.5, height: view.frame.height * 1.5))
    
    /// Правый толстый индикатор
    lazy var sideViewRightThickIndicator = UIView(frame: CGRect(x: (view.frame.width - view.frame.height * 1.5) - view.safeAreaInsets.right, y: -view.frame.height/4, width: view.frame.height * 1.5, height: view.frame.height * 1.5))
    
    /// Дополнительное наполнение для Правого толстого индикатора
    lazy var auxiliarySideViewRightThickIndicator = UIView(frame: CGRect(x: (view.frame.width - view.frame.height * 1.5) - view.safeAreaInsets.right, y: -view.frame.height/4, width: view.frame.height * 1.5, height: view.frame.height * 1.5))
    
    /// Правый тонкий индикатор
    lazy var sideViewRightThinIndicator = UIView(frame: CGRect(x: (view.frame.width - view.frame.height * 1.5) - 6 - view.safeAreaInsets.right, y: -view.frame.height/4, width: view.frame.height * 1.5, height: view.frame.height * 1.5))
    
    /// Дополнительное наполнение для Правого тонкого индикатора
    lazy var auxiliarySideViewRightThinIndicator = UIView(frame: CGRect(x: (view.frame.width - view.frame.height * 1.5) - 6 - view.safeAreaInsets.right, y: -view.frame.height/4, width: view.frame.height * 1.5, height: view.frame.height * 1.5))
    
    /// Лэйбл левый
    lazy var labelLeft: UILabel = {
        let label = UILabel(frame: CGRect(x: 50, y: (view.frame.height - 30)/2, width: 30, height: 30))
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// Лэйбл правый
    lazy var labelRight: UILabel = {
        let label = UILabel(frame: CGRect(x: view.frame.width - 50 - view.safeAreaInsets.right, y: (view.frame.height - 30)/2, width: 30, height: 30))
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.backgroundColor = .clear
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK:- Life cyrcle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ///Настойка отображений Views
        setupViews()
        
        ///Изначально скрываем все индикаторы и дополнительные элементы
        hideAllIndicatorsAndLabels()
        
        sideViewLeftThickIndicator.backgroundColor = .clear
        sideViewLeftThinIndicator.backgroundColor = .clear
        sideViewRightThickIndicator.backgroundColor = .clear
        sideViewRightThinIndicator.backgroundColor = .clear
        
        addWedgeViewFirstForLeftThickIndicator(color: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 0.5), angle: .pi, view: sideViewLeftThickIndicator, koeficientToFill: 1)
        addWedgeViewSecondForThinIndicator(color: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), angle: .pi, view: sideViewLeftThinIndicator, koeficientToFill: 1)
        
        addWedgeViewThirdForRightThickIndicator(color: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 0.5), angle: 0, view: sideViewRightThickIndicator, koeficientToFill: 1)
        addWedgeViewSecondForThinIndicator(color: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), angle: 0, view: sideViewRightThinIndicator, koeficientToFill: 1)
        
        addTriangleView(colorSetFill: #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 0.5), colorSetStroke: #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 0.5), lineWidth: 0, view: simpleTriangleView)
        
        addTriangleView(colorSetFill: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 0.3), colorSetStroke: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 0.6), lineWidth: 3, view: capitalTriangleButtonView)
    }
    
    override func viewWillLayoutSubviews() {
        /// Настраиваем элементы относительно возможных изменений отступа правого края экрана устройства
        /// Правый толстый индикатор
        sideViewRightThickIndicator.frame = CGRect(
            x: (view.frame.width - view.frame.height * 1.5) - view.safeAreaInsets.right,
            y: -view.frame.height/4,
            width: view.frame.height * 1.5,
            height: view.frame.height * 1.5)
        
        /// Дополнительное наполнение для Правого толстого индикатора
        auxiliarySideViewRightThickIndicator.frame = CGRect(
            x: (view.frame.width - view.frame.height * 1.5) - view.safeAreaInsets.right,
            y: -view.frame.height/4,
            width: view.frame.height * 1.5,
            height: view.frame.height * 1.5)
        
        /// Правый тонкий индикатор
        sideViewRightThinIndicator.frame = CGRect(
            x: (view.frame.width - view.frame.height * 1.5) - 6 - view.safeAreaInsets.right,
            y: -view.frame.height/4,
            width: view.frame.height * 1.5,
            height: view.frame.height * 1.5)
        
        /// Дополнительное наполнение Правого толстого индикатора
        auxiliarySideViewRightThinIndicator.frame = CGRect(
            x: (view.frame.width - view.frame.height * 1.5) - 6 - view.safeAreaInsets.right,
            y: -view.frame.height/4,
            width: view.frame.height * 1.5,
            height: view.frame.height * 1.5)
        
        labelRight.frame = CGRect(
            x: view.frame.width - 30 - 50 - view.safeAreaInsets.right,
            y: (view.frame.height - 30)/2,
            width: 30,
            height: 30)
        
        ///Основной Треугольник-Кнопка
        capitalTriangleButtonView.frame = CGRect(
            x: (view.frame.width - 100)/2,
            y: (view.frame.height - 90)/2,
            width: 100,
            height: 90)
        
        //Дополнительный Треугольник
        simpleTriangleView.center = capitalTriangleButtonView.center
        
        UIView.animate(withDuration: 2, delay: 1, options: [.repeat], animations: {
            self.simpleTriangleView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        }) { (finished) in
            
            self.simpleTriangleView.transform = CGAffineTransform.identity
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.videoPreviewLooper.frame = view.bounds
        
        self.videoPreviewLooper.backgroundColor = .black
        
        self.videoPreviewLooper.showVideo(from: localFirstURL)
        
        self.labelLeft.text = ""
        
        self.labelRight.text = ""
        
        self.timerForInteractiveGame = setupTimer()
        
        startTimer(timer: self.timerForInteractiveGame)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopTimer(timer: self.timerForInteractiveGame)
    }
    
    // MARK:- Actions
    
    @objc func interactiveButtonTapped() {
        
        print("Кнопка была нажата")
        
        self.videoPreviewLooper.showVideo(from: localSecondURL)
        
        stopTimer(timer: timerForInteractiveGame)
        
    }
    
    // MARK:- Setups
    
    private func setupViews() {
        
        view.backgroundColor = .white
        
        //Добавляем на основную View сущность для отображения Видео
        view.addSubview(videoPreviewLooper)
        
        //Устанавливаем отклик для Треугольника-кнопки
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(interactiveButtonTapped))
        capitalTriangleButtonView.isUserInteractionEnabled = true
        capitalTriangleButtonView.addGestureRecognizer(tapRecognizer)
        
        //Устанавливаем индикаторы для Левого края
        //Левый толстый индикатор и дополнительный к нему
        view.addSubview(sideViewLeftThickIndicator)
        view.addSubview(auxiliarySideViewLeftThickIndicator)
        
        //Левый тонкий индикатор и дополнительный к нему
        view.addSubview(sideViewLeftThinIndicator)
        view.addSubview(auxiliarySideViewLeftThinIndicator)
        
        //Устанавливаем индикаторы для Правого края
        //Правый толстый индикатор и дополнительный к нему
        view.addSubview(sideViewRightThickIndicator)
        view.addSubview(auxiliarySideViewRightThickIndicator)
        
        //Правый тонкий индикатор и дополнительный к нему
        view.addSubview(sideViewRightThinIndicator)
        view.addSubview(auxiliarySideViewRightThinIndicator)
        
        //Устанавливаем треугольники для кнопки
        view.addSubview(simpleTriangleView)
        view.addSubview(capitalTriangleButtonView)
        
        //Устанавливаем Лейблы – Левый и Правый
        view.addSubview(labelLeft)
        view.addSubview(labelRight)
    }
    
    /// Задаем необходимые настройки и условия работы для Таймера
    private func setupTimer() -> Timer{
        
        let timer = Timer(timeInterval: 1, repeats: true) { timerNew in
            
            
            self.currentVideoDuration = self.getCurrentVideoDuration()
            
            self.currentVideoCurrentTime = self.getCurrentVideoCurrentTime()
            
            if (Int(self.currentVideoDuration) - Int(self.currentVideoCurrentTime) < 34) {
                if self.shouldToDisplayAllIndicators {
                    self.displayAllIndicatorsAndLabelsWithAnimation()
                    self.counterOfTimerForInteractiveGame = Int(self.currentVideoDuration) -  Int(self.currentVideoCurrentTime) - 2
                }
                
                self.shouldToDisplayAllIndicators = false
                self.counterOfTimerForInteractiveGame -= 1
                
                //Запускаем анимированное движение кнопки по экрану, каждые 2 секунды
                if self.counterOfTimerForInteractiveGame % 2 == 1 {
                    self.startMoveTriangleButton()
                }
                
                self.labelLeft.text = "\(self.counterOfTimerForInteractiveGame)"
                self.labelRight.text = "\(self.counterOfTimerForInteractiveGame)"
                
                if self.counterOfTimerForInteractiveGame < 10{
                    self.labelLeft.textColor = .red
                    self.labelRight.textColor = .red
                    
                    //Заполнение Левого тонкого индикатора
                    self.addWedgeViewSecondForThinIndicator(color: #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 0.8), angle: .pi, view: self.auxiliarySideViewLeftThinIndicator, koeficientToFill: CGFloat(self.counterOfTimerForInteractiveGame))
                    
                    //Заполнение Левого толстого индикатора
                    self.addWedgeViewFirstForLeftThickIndicator(color: #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 0.4), angle: .pi, view: self.auxiliarySideViewLeftThickIndicator, koeficientToFill: CGFloat(self.counterOfTimerForInteractiveGame))
                    
                    //Заполнение Правого тонкого индикатора
                    self.addWedgeViewSecondForThinIndicator(color: #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 0.8), angle: 0, view: self.auxiliarySideViewRightThinIndicator, koeficientToFill: CGFloat(self.counterOfTimerForInteractiveGame))
                    
                    //Заполнение Правого тонкого индикатора
                    self.addWedgeViewThirdForRightThickIndicator(color: #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 0.4), angle: 0, view: self.auxiliarySideViewRightThickIndicator, koeficientToFill: CGFloat(self.counterOfTimerForInteractiveGame))
                    
                } else {
                    self.labelLeft.textColor = .white
                    self.labelRight.textColor = .white
                }
                
                if self.counterOfTimerForInteractiveGame == 0 {
                    
                    self.labelLeft.textColor = .systemBlue
                    
                    self.labelRight.textColor = .systemBlue
                    
                    timerNew.invalidate()
                    
                    self.hideAllIndicatorsAndLabelsWithAnimation()
                    
                    self.videoPreviewLooper.showVideo(from: self.streamURL)
                }
            }
        }
        timer.tolerance = 0.3
        return timer
    }
    
    // MARK:- Methods
    
    ///Подгружаем данные по Длительности видео
    private func getCurrentVideoDuration() -> Float {
        
        var videoDuration: Float
        
        guard let videoDurationCMTimeValue = self.videoPreviewLooper.videoPlayerView.player?.currentItem?.duration.value  else { return 0}
        
        guard let videoDurationCMTimescale = self.videoPreviewLooper.videoPlayerView.player?.currentItem?.duration.timescale  else { return 0}
        
        if videoDurationCMTimescale > 0 {
            videoDuration = Float(videoDurationCMTimeValue) / Float(videoDurationCMTimescale)
        } else {
            videoDuration = 0
        }
        
        return videoDuration
    }
    
    ///Подгружаем данные по Текущему времени видео
    private func getCurrentVideoCurrentTime() -> Float {
        
        var videoCurrentTime: Float
        
        guard let videoCurrentTimeCMTimeValue = self.videoPreviewLooper.videoPlayerView.player?.currentItem?.currentTime().value  else { return 0 }
        
        guard let videoCurrentTimeCMTimescale = self.videoPreviewLooper.videoPlayerView.player?.currentItem?.currentTime().timescale  else { return 0}
        
        if videoCurrentTimeCMTimescale > 0 {
            videoCurrentTime = Float(videoCurrentTimeCMTimeValue) / Float(videoCurrentTimeCMTimescale)
        } else {
            videoCurrentTime = 0
        }
        
        return videoCurrentTime
    }
    
    /// Запуск в движение Треугольника-кнопки
    func startMoveTriangleButton() {
        DispatchQueue.main.async {
            
            let xRandom = CGFloat.random(in: self.labelLeft.frame.maxX...(self.labelRight.frame.minX - self.capitalTriangleButtonView.frame.width))
            let yRandom = CGFloat.random(in: 0...(self.view.frame.height - self.capitalTriangleButtonView.frame.height))
            
            UIViewPropertyAnimator(duration: 2, curve: .easeInOut) {
                self.capitalTriangleButtonView.frame = CGRect(
                    x: xRandom,
                    y: yRandom,
                    width: 100,
                    height: 90)
                
                self.simpleTriangleView.center = self.capitalTriangleButtonView.center
                
            }.startAnimation()
        }
    }
    
    /// Запуск Таймера
    private func startTimer(timer: Timer) -> Void {
        RunLoop.main.add(timer, forMode: .common)
    }
    
    /// Остановка таймера
    private func stopTimer(timer: Timer) {
        self.counterOfTimerForInteractiveGame = 0
        timer.invalidate()
        hideAllIndicatorsAndLabelsWithAnimation()
        
    }
    
    /// Анимированное скрытие всех индикаторов и дополнительных элементов
    func hideAllIndicatorsAndLabelsWithAnimation(){
        
        UIViewPropertyAnimator(duration: 1, curve: .linear) {
            self.hideAllIndicatorsAndLabels()
        }.startAnimation()
        
    }
    
    /// Скрытие всех индикаторов и дополнительных элементов
    func hideAllIndicatorsAndLabels(){
        
        //Убираем индикаторы для Левого края
        //Левый толстый индикатор и дополнительный к нему
        
        //Убираем индикаторы для Левого края
        //Левый толстый индикатор и дополнительный к нему
        self.sideViewLeftThickIndicator.alpha = 0
        self.auxiliarySideViewLeftThickIndicator.alpha = 0
        
        //Левый тонкий индикатор и дополнительный к нему
        self.sideViewLeftThinIndicator.alpha = 0
        self.auxiliarySideViewLeftThinIndicator.alpha = 0
        
        //Убираем индикаторы для Правого края
        //Правый толстый индикатор и дополнительный к нему
        self.sideViewRightThickIndicator.alpha = 0
        self.auxiliarySideViewRightThickIndicator.alpha = 0
        
        //Правый тонкий индикатор и дополнительный к нему
        self.sideViewRightThinIndicator.alpha = 0
        self.auxiliarySideViewRightThinIndicator.alpha = 0
        
        //Убираем треугольники
        self.simpleTriangleView.alpha = 0
        self.capitalTriangleButtonView.alpha = 0
        self.capitalTriangleButtonView.isUserInteractionEnabled = false
        
        //Убираем Лейблы – Левый и Правый
        self.labelLeft.alpha = 0
        self.labelRight.alpha = 0
    }
    
    /// Отображение всех индикаторов и дополнительных элементов
    func displayAllIndicatorsAndLabels(){
        
        //Показываем индикаторы для Левого края
        //Левый толстый индикатор и дополнительный к нему
        self.sideViewLeftThickIndicator.alpha = 0.5
        self.auxiliarySideViewLeftThickIndicator.alpha = 0.5
        
        //Левый тонкий индикатор и дополнительный к нему
        self.sideViewLeftThinIndicator.alpha = 1
        self.auxiliarySideViewLeftThinIndicator.alpha = 1
        
        //Показываем индикаторы для Правого края
        //Правый толстый индикатор и дополнительный к нему
        self.sideViewRightThickIndicator.alpha = 0.5
        self.auxiliarySideViewRightThickIndicator.alpha = 0.5
        
        //Правый тонкий индикатор и дополнительный к нему
        self.sideViewRightThinIndicator.alpha = 1
        self.auxiliarySideViewRightThinIndicator.alpha = 1
        
        //Показываем треугольники
        self.simpleTriangleView.alpha = 0.5
        self.capitalTriangleButtonView.alpha = 0.3
        self.capitalTriangleButtonView.isUserInteractionEnabled = true
        
        //Показываем Лейблы – Левый и Правый
        self.labelLeft.alpha = 1
        self.labelRight.alpha = 1
        
    }
    
    /// Анимированное отображение всех индикаторов и дополнительных элементов
    func displayAllIndicatorsAndLabelsWithAnimation(){
        UIViewPropertyAnimator(duration: 1, curve: .linear) {
            self.displayAllIndicatorsAndLabels()
        }.startAnimation()
    }
    
    /// Добавление Левого Толстого Индикатора
    func addWedgeViewFirstForLeftThickIndicator(color: UIColor, angle: Radians, view: UIView, koeficientToFill: CGFloat) {
        DispatchQueue.main.async {
            let wedgeViewFirstForLeftThickIndicator = SimonWedgeViewFirstForLeftThickIndicator(frame: view.bounds, koeficientToFill: koeficientToFill)
            wedgeViewFirstForLeftThickIndicator.color = color
            wedgeViewFirstForLeftThickIndicator.centerAngle = angle
            view.addSubview(wedgeViewFirstForLeftThickIndicator)
        }
    }
    
    /// Добавление Тонкого Индикатора
    func addWedgeViewSecondForThinIndicator(color: UIColor, angle: Radians, view: UIView, koeficientToFill: CGFloat) {
        DispatchQueue.main.async {
            let wedgeView = SimonWedgeViewSecondForThinIndicator(frame: view.bounds, koeficientToFill: koeficientToFill)
            wedgeView.color = color
            wedgeView.centerAngle = angle
            view.addSubview(wedgeView)
        }
    }
    
    /// Добавление Правого Толстого Индикатора
    func addWedgeViewThirdForRightThickIndicator(color: UIColor, angle: Radians, view: UIView, koeficientToFill: CGFloat) {
        DispatchQueue.main.async {
            let wedgeView = SimonWedgeViewThirdForRightThickIndicator(frame: view.bounds, koeficientToFill: koeficientToFill)
            wedgeView.color = color
            wedgeView.centerAngle = angle
            view.addSubview(wedgeView)
        }
    }
    
    /// Добавление Треугольника
    func addTriangleView(colorSetFill: UIColor, colorSetStroke: UIColor, lineWidth: CGFloat, view: UIView) {
        let triangleView = TriangleWedgeView(frame: view.bounds)
        triangleView.colorSetFill = colorSetFill
        triangleView.colorSetStroke = colorSetStroke
        triangleView.lineWidth = lineWidth
        view.addSubview(triangleView)
    }
}

// MARK:- Extension

typealias Radians = CGFloat

extension UIBezierPath {
    
    /// Настройка углов внешнего и наружного, а также вогнутости для Левого толстого индикатора
    static func simonWedgeFirstForLeftThickIndicator(innerRadius: CGFloat, outerRadius: CGFloat, centerAngle: Radians, koeficient: CGFloat) -> UIBezierPath {
        let innerAngle: Radians = CGFloat.pi / (6.3 * koeficient)
        let outerAngle: Radians = CGFloat.pi / (6 * koeficient)
        let path = UIBezierPath()
        
        path.addArc(withCenter: .init(x: -innerRadius/6, y: 0), radius: innerRadius, startAngle: centerAngle - innerAngle - innerAngle/10, endAngle: centerAngle + innerAngle + innerAngle/10, clockwise: true)
        path.addArc(withCenter: .zero, radius: outerRadius, startAngle: centerAngle + outerAngle, endAngle: centerAngle - outerAngle, clockwise: false)
        path.close()
        return path
    }
    
    /// Настройка углов внешнего и наружного, а также вогнутости для обоих тонких индикаторов
    static func simonWedgeSecondForThinIndicator(innerRadius: CGFloat, outerRadius: CGFloat, centerAngle: Radians, koeficient: CGFloat) -> UIBezierPath {
        let innerAngle: Radians = CGFloat.pi / (6 * koeficient)
        let outerAngle: Radians = CGFloat.pi / (6 * koeficient)
        let path = UIBezierPath()
        path.addArc(withCenter: .zero, radius: innerRadius, startAngle: centerAngle - innerAngle, endAngle: centerAngle + innerAngle, clockwise: true)
        path.addArc(withCenter: .zero, radius: outerRadius, startAngle: centerAngle + outerAngle, endAngle: centerAngle - outerAngle, clockwise: false)
        path.close()
        return path
    }
    
    /// Настройка углов внешнего и наружного, а также вогнутости для Правого толстого индикатора
    static func simonWedgeThirdForRightThickIndicator(innerRadius: CGFloat, outerRadius: CGFloat, centerAngle: Radians, koeficient: CGFloat) -> UIBezierPath {
        let innerAngle: Radians = CGFloat.pi / (6.3 * koeficient)
        let outerAngle: Radians = CGFloat.pi / (6 * koeficient)
        let path = UIBezierPath()
        path.addArc(withCenter: .init(x: innerRadius/6, y: 0), radius: innerRadius, startAngle: centerAngle - innerAngle - innerAngle/10, endAngle: centerAngle + innerAngle + innerAngle/10, clockwise: true)
        path.addArc(withCenter: .zero, radius: outerRadius, startAngle: centerAngle + outerAngle, endAngle: centerAngle - outerAngle, clockwise: false)
        path.close()
        return path
    }
}

