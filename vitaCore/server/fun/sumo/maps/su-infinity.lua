suArenaInfinity = {
createObject(10027,-3119.3994000,633.2002000,11.7000000,0.0000000,0.0000000,0.0000000), --object(bigwhiete_sfe) (2)
createObject(10027,-3119.3999000,716.5000000,11.7000000,0.0000000,0.0000000,180.0000000), --object(bigwhiete_sfe) (2)
createObject(3458,-3138.8000000,672.5999800,65.4100000,10.0000000,0.0000000,0.0000000), --object(vgncarshade1) (1)
createObject(3458,-3138.8000000,677.0999800,65.4100000,9.9980000,0.0000000,180.0000000), --object(vgncarshade1) (2)
createObject(3458,-3100.0000000,672.5999800,65.4000000,9.9980000,0.0000000,0.0000000), --object(vgncarshade1) (3)
createObject(3458,-3100.0000000,677.0999800,65.4000000,9.9980000,0.0000000,179.9950000), --object(vgncarshade1) (4)
}

for i, element in ipairs(suArenaInfinity) do
	setElementDimension(element, gGamemodeFUN+100)
end

suSpawnsInfinity = {
    {posX=-3152.2998,posY=603.40039,posZ=67.2,rotX=0,rotY=0,rotZ=0},
    {posX=-3084.2002,posY=602.5,posZ=67.2,rotX=0,rotY=0,rotZ=0},
    {posX=-3086.5,posY=661.7998,posZ=67.3,rotX=0,rotY=0,rotZ=179.995},
    {posX=-3148.3994,posY=662.09961,posZ=67.3,rotX=0,rotY=0,rotZ=179.995},
    {posX=-3151.2002,posY=745.40039,posZ=67.3,rotX=0,rotY=0,rotZ=179.995},
    {posX=-3087,posY=745.7002,posZ=67.3,rotX=0,rotY=0,rotZ=179.995},
    {posX=-3086.2002,posY=687.90039,posZ=67.3,rotX=0,rotY=0,rotZ=0}
}
