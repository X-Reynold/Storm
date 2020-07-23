
version="v1.0.01";

--local pageSetting =

function mainViewDidLoad(vcView) -- 方法绑定 

	changeColor(vcView)

	print("view did load")

    local view = normalView("bg:blue")
    -- local view = normalView("bg:yellow")
    -- view.tag=20
    addSubView(view) 
    -- free(view)
    freeObjects() -- 释放内存
   -- local view1 = normalView("bg:yellow")
   -- addSubview("413")

end

--funcVal();
