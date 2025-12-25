from ia.chat import ask_ai

print(r"""
  __                               __   
_/  |_ __ _____  ___  ____ _______/  |_ 
\   __\  |  \  \/  / / ___\\____ \   __\
 |  | |  |  />    < / /_/  >  |_> >  |  
 |__| |____//__/\_ \\___  /|   __/|__|  
                  \/_____/ |__|       
 """)

try:
    while True:
        user = input(">> ")
        if user.lower() == "salir":
            break
        response = ask_ai(user)
        print("\nIA >", response, "\n")
except KeyboardInterrupt:
    print("\nCerrando IA...")
