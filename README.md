# CEP & GSW FROM JRC - Analysis
Combines CEP and GSW tiles from JRC 


# Running Notebooks in chronological order
The notebooks in this repository should be run in the following order:
1. '1_Tiff_Matcher_Osgeo' OR '1_Tiff_Matcher_Iteration.ipynb'
2. '2_Grass_Tile_Processor.ipynb'
3. '3_Merging_Outputs.ipynb'
4. '4_PostGIS_Local.ipynb' (see docker setup below) OR '4_PostGIS_Cloud.ipynb'

## Docker Setup
1. From the project root directory, run the command 
    ```sh
    docker-compose up
    ```