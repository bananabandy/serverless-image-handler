from pkg_resources import get_distribution
import sys
sys.path.insert(0,'/var/task/bin')
__version__ = get_distribution('image_handler').version
__release_date__ = "01-sep-2017"
