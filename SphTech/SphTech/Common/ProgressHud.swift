//
//  ProgressHud.swift
//  SphTech
//
//  Created by ninh nam on 4/22/20.
//  Copyright © 2020 ninh nam. All rights reserved.
//

import UIKit

class ProgressHud: UIView
{
    private var backGroundView : UIView?
    private var progressIndicator : UIActivityIndicatorView?
    private var titleLabel : UILabel?
    private var footerLabel : UILabel?
    
    var headerColor : UIColor
    var footerColor : UIColor
    var backGroundColor : UIColor
    var loaderColor : UIColor
    
    static let shareHud = ProgressHud()
        
    init()
    {
        headerColor = UIColor.white
        footerColor = UIColor.white
        backGroundColor = UIColor.lightGray
        loaderColor = UIColor.white
        
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        headerColor = UIColor.white
        footerColor = UIColor.white
        backGroundColor = UIColor.lightGray
        loaderColor = UIColor.white
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect)
    {
        headerColor = UIColor.white
        footerColor = UIColor.white
        backGroundColor = UIColor.lightGray
        loaderColor = UIColor.white
        super.init(frame: frame)
    }
    
    func showInView(view : UIView, withHeader title : String?, andFooter footer : String?, isShowLoading: Bool)
    {
        self.hide()
        self.frame = view.frame
        setIndicator()
        if isShowLoading
        {
            
            if title != nil && !isCleanedStringEmpty(string: title!)
            {
                setTitleLabel(text: title!)
                titleLabel!.frame=CGRect(x: 0, y: 0, width: getLabelSize().width, height: getLabelSize().height)
            }
            if footer != nil && !isCleanedStringEmpty(string: footer!)
            {
                setFooterLabel(text: footer!)
                footerLabel!.frame=CGRect(x: 0, y: 0, width: getLabelSize().width, height: getLabelSize().height)
            }
            setBackGround(view: self)
            if title != nil && !isCleanedStringEmpty(string: title!)
            {
                titleLabel!.frame.origin = getHeaderOrigin(view: backGroundView!)
                titleLabel?.adjustsFontSizeToFitWidth = true
                backGroundView?.addSubview(titleLabel!)
            }
            if footer != nil && !isCleanedStringEmpty(string: footer!)
            {
                footerLabel!.frame.origin = getFooterOrigin(view: backGroundView!)
                footerLabel?.adjustsFontSizeToFitWidth = true
                backGroundView?.addSubview(footerLabel!)
            }
            progressIndicator?.frame.origin = getIndicatorOrigin(view: backGroundView!, activityIndicatorView: progressIndicator!)
            backGroundView?.addSubview(progressIndicator!)
            view.addSubview(self)
        }
        else
        {
            progressIndicator?.stopAnimating()
        }
    }
    
    func showInViewWithNoLoading(view : UIView)
    {
        self.showInView(view: view, withHeader: nil, andFooter: nil, isShowLoading: false)
    }
    
    // Show the loader added to the mentioned view with no title and footer texts
    func showInView(view : UIView)
    {
        self.showInView(view: view, withHeader: nil, andFooter: nil, isShowLoading: true)
    }
    
    func showInViewLoadingWithTitleAndHeader(view : UIView)
    {
        self.showInView(view: view, withHeader: "Loading", andFooter: "Please wait", isShowLoading: true)
    }
    
    // Removes the loader from its superview
    func hide()
    {
        if self.superview != nil
        {
            self.removeFromSuperview()
            progressIndicator?.stopAnimating()
        }
    }
    
    // MARK:- Set view properties
    
    private func setBackGround(view : UIView)
    {
        if backGroundView?.superview != nil
        {
            backGroundView?.removeFromSuperview()
            let aView = backGroundView?.viewWithTag(1001) as UIView?
            aView?.removeFromSuperview()
        }
        backGroundView = UIView(frame: getBackGroundFrame(view: self))
        //        backGroundView?.backgroundColor = UIColor.grayColor()
        backGroundView?.backgroundColor=UIColor.clear
        
        let translucentView = UIView(frame: backGroundView!.bounds)
        translucentView.backgroundColor = UIColor.black
        translucentView.alpha = 0.3
        translucentView.tag = 1001
        translucentView.layer.cornerRadius = 15.0
        backGroundView?.addSubview(translucentView)
        backGroundView?.layer.cornerRadius = 15.0
        self.addSubview(backGroundView!)
    }
    
    private func setIndicator()
    {
        if progressIndicator?.superview != nil
        {
            progressIndicator?.removeFromSuperview()
        }
        progressIndicator = UIActivityIndicatorView(style: .whiteLarge)
        progressIndicator?.style = UIActivityIndicatorView.Style.whiteLarge
        progressIndicator?.color = loaderColor
        progressIndicator?.backgroundColor = UIColor.clear
        progressIndicator?.startAnimating()
    }
    
    private func setTitleLabel(text : String)
    {
        if titleLabel?.superview != nil
        {
            titleLabel?.removeFromSuperview()
        }
        titleLabel = UILabel()
        titleLabel?.text = text
        titleLabel?.font = self.boldFontWithFont(font: titleLabel?.font)
        titleLabel?.textColor = headerColor
        titleLabel?.textAlignment = .center
    }
    
    private func setFooterLabel(text : String)
    {
        if footerLabel?.superview != nil
        {
            footerLabel?.removeFromSuperview()
        }
        footerLabel = UILabel()
        footerLabel?.text = text
        footerLabel?.textColor = footerColor
        footerLabel?.textAlignment = .center
    }
    
    // MARK:- Get Frame
    
    private func getBackGroundFrame(view : UIView) -> CGRect
    {
        let sideMargin:CGFloat = 20.0
        var side = progressIndicator!.frame.height + sideMargin
        if titleLabel?.text != nil && !isCleanedStringEmpty(string: titleLabel!.text!)
        {
            side = progressIndicator!.frame.height + titleLabel!.frame.width
        }
        else if (footerLabel?.text != nil && !isCleanedStringEmpty(string: footerLabel!.text!))
        {
            side = progressIndicator!.frame.height + footerLabel!.frame.width
        }
        let originX = view.center.x - (side/2)
        let originY = view.center.y - (side/2)
        return CGRect(x: originX, y: originY, width: side, height: side)
    }
    
    // MARK:- Get Size
    
    private func getLabelSize() -> CGSize
    {
        let width = progressIndicator!.frame.width * 3
        let height = progressIndicator!.frame.height / 1.5
        return CGSize(width: width, height: height)
    }
    
    // MARK:- Get Origin
    
    private func getIndicatorOrigin(view : UIView, activityIndicatorView indicator : UIActivityIndicatorView) -> CGPoint
    {
        let side = indicator.frame.size.height
        let originX = (view.bounds.width/2) - (side/2)
        let originY = (view.bounds.height/2) - (side/2)
        return CGPoint(x: originX, y: originY)
    }
    
    private func getHeaderOrigin(view : UIView) -> CGPoint
    {
        let width = titleLabel!.frame.size.width
        let originX = (view.bounds.width/2) - (width/2)
        return CGPoint(x: originX, y: 1)
    }
    
    private func getFooterOrigin(view : UIView) -> CGPoint
    {
        let width = footerLabel!.frame.width
        let height = footerLabel!.frame.height
        let originX = (view.bounds.width/2) - (width/2)
        let originY = view.frame.height - (height + 1)
        return CGPoint(x: originX, y: originY)
    }
    
    private func isCleanedStringEmpty(string: String) -> Bool
    {
        let cleanString=string.trimmingCharacters(in: NSCharacterSet.whitespaces)
        return cleanString.isEmpty
    }
    
    // MARK:- Set Font
    func boldFontWithFont(font : UIFont?) -> UIFont
    {
        let fontDescriptor : UIFontDescriptor = font!.fontDescriptor.withSymbolicTraits(.traitBold)!
        return UIFont(descriptor: fontDescriptor, size: 0)
    }
  
}
