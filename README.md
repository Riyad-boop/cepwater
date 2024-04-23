# CEP & GSW FROM JRC - Analysis
Combines CEP and GSW tiles from JRC 


# Running Notebooks in chronological order
The notebooks in this repository should be run in the following order:
1. '1_Tiff_Matcher_Osgeo' OR '1_Tiff_Matcher_Iteration.ipynb' (setting up Osgeo is not included in this repo, but is necessary for the first notebook - see anaconda for quick setup)
2. '2_Grass_Tile_Processor.ipynb'
3. '3_Merging_Outputs.ipynb' OR '3_Merging_Outputs_with qids.ipynb' (if the '1_Tiff_Matcher_Iteration.ipynb' was used in step 1 - so the tiles have names)
4. '4_PostGIS_Write.ipynb' (see docker setup if using local mode below)
5. '5_PostGIS_Analysis.ipynb'
6.  some useful sql scripts are in the 'sql_scripts' folder
    6.1 'sql_scripts/CEP_idGrouper.pgsql' - sums the transition bands by the unique cep_id
    6.2 'sql_scripts/TransitionGrouperViews.pgsql' - creates a view that sums seasonal and permanent bands from 1985 and 2015
## Docker Setup
1. From the project root directory, run the command 
    ```sh
    docker-compose up
    ```