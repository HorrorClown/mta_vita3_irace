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
		subElement:delete()
	end
	
	self.m_RenderTarget:destroy()
end

function GUIArea:updateRenderTarget()
	self.m_RenderTarget:setAsTarget(true)
	for _, subElement in ipairs(self.subElements) do
		subElement:render()
	end
	dxSetRenderTarget()
	
	return self.m_Parent:updateRenderTarget(true)	--todo tail call
end

function GUIArea:render()
	if not self.m_Enabled then return end

	dxDrawImage(self.diffX, self.diffY, self.w, self.h, self.m_RenderTarget)
end