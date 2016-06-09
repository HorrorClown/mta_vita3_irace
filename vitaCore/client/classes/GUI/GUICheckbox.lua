GUICheckbox = inherit(GUIManager)

function GUICheckbox:constructor(sText, nDiffX, nDiffY, nWidth, nHeight, parent)
	self.m_Enabled = true
	self.m_Parent = parent
	self.m_Checked = false
	self.diffX = nDiffX
    self.diffY = nDiffY
    self.w = nWidth
    self.h = nHeight
	self.clickExecute = {}
	if self.m_Parent.subElements then table.insert(self.m_Parent.subElements, self) end
	
	self.fn_ToggleChecked = function() self.m_Checked = not self.m_Checked end
	self:addClickFunction(self.fn_ToggleChecked)
end

function GUICheckbox:destructor()
	self:removeClickFunction(self.fn_ToggleChecked)
end

function GUICheckbox:render()
	if not self.m_Enabled then return end

	dxDrawRectangle(self.diffX, self.diffY, self.h, self.h, tocolor(255, 255, 255)
	if self.m_Checked then dxDrawRectangle(self.diffX + 2, self.diffY + 2, self.h - 4, self.h - 4, tocolor(85, 85, 85)) end
	
	dxDrawText(self.title, self.x + self.h + 2, self.y, self. x + self.w, self. y + self.h, tocolor(255, 255, 255), 1, "arial", "left", "center")
end