classdef MimEnterMarkerMode < MimGuiPlugin
    % MimEnterMarkerMode. Gui Plugin for entering marker edit mode
    %
    %     You should not use this class within your own code. It is intended to
    %     be used by the gui of the Pulmonary Toolkit.
    %
    %     MimEnterMarkerMode is a Gui Plugin for entering or leaving marker mode.
    %
    %
    %     Licence
    %     -------
    %     Part of the TD Pulmonary Toolkit. https://github.com/tomdoel/pulmonarytoolkit
    %     Author: Tom Doel, 2014.  www.tomdoel.com
    %     Distributed under the GNU GPL v3 licence. Please see website for details.
    %    
    
    properties
        ButtonText = 'Edit Markers'
        SelectedText = 'Hide Markers'
        ToolTip = 'Enters marker edit mode'
        Category = 'Show / hide'
        Visibility = 'Dataset'
        Mode = 'Toolbar'

        HidePluginInDisplay = false
        PTKVersion = '2'
        ButtonWidth = 6
        ButtonHeight = 1
        Location = 11
        Icon = 'markers.png'
    end
    
    methods (Static)
        function RunGuiPlugin(ptk_gui_app)
            if ptk_gui_app.ImagePanel.IsInMarkerMode
                ptk_gui_app.ImagePanel.SetControl('W/L');
            else
                ptk_gui_app.ImagePanel.SetControl('Mark');
            end
            
        end

        function enabled = IsEnabled(ptk_gui_app)
            enabled = ptk_gui_app.IsDatasetLoaded;
        end
        
        function is_selected = IsSelected(ptk_gui_app)
            is_selected = ptk_gui_app.ImagePanel.IsInMarkerMode;
        end
    end
end