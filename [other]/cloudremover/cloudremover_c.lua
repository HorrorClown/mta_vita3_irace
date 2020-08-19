local cloudFiles = {
	{["name"] = "cloud1", ["txd"] = dxCreateTexture("files/cloud1.png")},
	{["name"] = "cloudhigh", ["txd"] = dxCreateTexture("files/cloudhigh.png")},
	{["name"] = "cloudmasked", ["txd"] = dxCreateTexture("files/cloudmasked.png")},
	{["name"] = "Sky", ["txd"] = dxCreateTexture("files/Sky.png")},
	{["name"] = "Sky2", ["txd"] = dxCreateTexture("files/Sky2.png")},
	{["name"] = "Sky3", ["txd"] = dxCreateTexture("files/Sky3.png")},
	{["name"] = "Skysnow", ["txd"] = dxCreateTexture("files/Skysnow.png")},
}

addEventHandler("onClientResourceStart", resourceRoot,
	function()
		for i,file in ipairs(cloudFiles) do
			local theShader = dxCreateShader("files/globshader.fx")
			dxSetShaderValue(theShader, "xTxd", file["txd"])
			engineApplyShaderToWorldTexture(theShader, file["name"])
		end
	end
)