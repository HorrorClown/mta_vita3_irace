GUICheckbox = inherit(GUIManager)

function GUICheckbox:constructor(sText, nDiffX, nDiffY, nWidth, nHeight, parent)
	self.parent = parent
	self.m_Enabled = self.parent.m_Enabled
	self.m_Checked = false
	self.title = sText
	self.diffX = nDiffX
    self.diffY = nDiffY
    self.w = nWidth
    self.h = nHeight
	self.clickExecute = {}
	if self.parent.subElements then table.insert(self.parent.subElements, self) end
	
	self.fn_ToggleChecked = function() self.m_Checked = not self.m_Checked self.parent:updateRenderTarget() end
	self:addClickFunction(self.fn_ToggleChecked)
	self:addClickHandler()
end

function GUICheckbox:destructor()
	self:removeClickFunction(self.fn_ToggleChecked)
end

function GUICheckbox:getText()
	return self.title
end

function GUICheckbox:setText(sText)
	self.title = sText
end

function GUICheckbox:setSelected(state)
	self.m_Checked = state
end

function GUICheckbox:getSelected()
	return self.m_Checked
end

function GUICheckbox:render()
	if not self.m_Enabled then return end

	dxDrawRectangle(self.diffX, self.diffY, self.h, self.h, tocolor(255, 255, 255))
	if self.m_Checked then dxDrawRectangle(self.diffX + 2, self.diffY + 2, self.h - 4, self.h - 4, tocolor(85, 85, 85)) end
	
	dxDrawText(self.title, self.diffX + self.h + 5, self.diffY, self.diffX + self.w, self.diffY + self.h, tocolor(255, 255, 255), 1, "arial", "left", "center")
end