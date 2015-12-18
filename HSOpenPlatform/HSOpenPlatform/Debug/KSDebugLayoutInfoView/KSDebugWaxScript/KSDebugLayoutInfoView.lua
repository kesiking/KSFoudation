local res = sv:subviews()
return res

sv:removeFromSuperview()
return sv:setBackgroundColor(UIColor:redColor())

label = UILabel:initWithFrame(CGRect(0, 0, 320, 100))
label:setBackgroundColor(UIColor:clearColor())
label:setFont(UIFont:boldSystemFontOfSize(30))
label:setText("ceshi")
sv:addSubview(label)