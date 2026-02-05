# Gym_sport_trainer
This is an application to follow the phisical activity at the gym or some sports.
For the moment it's only available on Windows.

### Necessary tools
- CMake
- MSVC compiler
- Qt6

To use the application you need to generate, compile and install the code in the repository.

- To generate :
cmake -S . -B build -DCMAKE_BUILD_TYPE=Release -G "Visual Studio 17 2022" -A x64 -DQt6_DIR=<put the path of Qt6> -DCMAKE_INSTALL_PREFIX=<put the path where you want to install the App (normally inside the build folder)>

- To compile :
cmake --build build --config Release

- To install
cmake --install build --config Release
