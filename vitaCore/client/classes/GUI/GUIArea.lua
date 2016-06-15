GUIArea = inherit(GUIManager)

function GUIArea:constructor(nDiffX, nDiffY, nWidth, nHeight, parent)
	self.m_Enabled = true
	self.m_Parent = parent
	self.diffX = nDiffX
    self.diffY = nDiffY
    self.w = nWidth
    self.h = nHeight
	self.subElements = {}
	if self.m_Parent.subElements then table.insert(self.m_Parent.subElements, self) end
	
	self.m_RenderTarget = DxRenderTarget(nWidth, nHeight, true)
end

function GUIArea:destructor()
	for _, subElement in ipairs(self.subElements) do
		delete(subElement)
	end
	
	self.m_RenderTarget:destroy()
end

function GUIArea:getPosition()
	if self.m_Parent then
		return self.m_Parent.x + self.diffX, self.m_Parent.y + self.diffY
	else
		return self.diffX, self.diffY
	end
end

function GUIArea:updateRenderTarget()
	self.m_RenderTarget:setAsTarget(true)
	for _, subElement in ipairs(self.subElements) do
		subElement:render(0)
	end
	dxSetRenderTarget()
	
	return self.m_Parent:updateRenderTarget(true)
end

function GUIArea:render()
	if not self.m_Enabled then return end

	--dxDrawRectangle(self.diffX, self.diffY, self.w, self.h, tocolor(255, 0, 0, 10))
	dxDrawImage(self.diffX, self.diffY, self.w, self.h, self.m_RenderTarget)
end