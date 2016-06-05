screenWidth, screenHeight = guiGetScreenSize()
screenSize = Vector2(screenWidth, screenHeight)
ASPECT_RATIO_MULTIPLIER = (screenWidth/screenHeight)/(16/9)

LOGIN_HEIGHT = screenHeight/3

MODEL_FOR_PICKUP_TYPE = {nitro = 2221, repair = 2222, vehiclechange = 2223}