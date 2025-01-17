/*!
 * Ext JS Library 3.0.0
 * Copyright(c) 2006-2009 Ext JS, LLC
 * licensing@extjs.com
 * http://www.extjs.com/license
 */
Ext.ns('Ext.ux');

Ext.ux.GroupTabPanel = Ext.extend(Ext.TabPanel, {
    tabPosition: 'left',
    
    alternateColor: false,
    
    alternateCls: 'x-grouptabs-panel-alt',
    
    defaultType: 'grouptab',
    
    deferredRender: false,
    
    activeGroup : null,
    
    initComponent: function(){
        Ext.ux.GroupTabPanel.superclass.initComponent.call(this);
        
        this.addEvents(
            'beforegroupchange',
            'groupchange'
        );
        this.elements = 'body,header';
        this.stripTarget = 'header';
        
        this.tabPosition = this.tabPosition == 'right' ? 'right' : 'left';
        
        this.addClass('x-grouptabs-panel');
        
        if (this.tabStyle && this.tabStyle != '') {
            this.addClass('x-grouptabs-panel-' + this.tabStyle);
        }
        
        if (this.alternateColor) {
            this.addClass(this.alternateCls);
        }
        
        this.on('beforeadd', function(gtp, item, index){
            this.initGroup(item, index);
        });		     
    },
    
    initEvents : function() {
        this.mon(this.strip, 'mousedown', this.onStripMouseDown, this);
    },
        
    onRender: function(ct, position){
        Ext.TabPanel.superclass.onRender.call(this, ct, position);

        if(this.plain){
            var pos = this.tabPosition == 'top' ? 'header' : 'footer';
            this[pos].addClass('x-tab-panel-'+pos+'-plain');
        }

        var st = this[this.stripTarget];

        this.stripWrap = st.createChild({cls:'x-tab-strip-wrap ', cn:{
            tag:'ul', cls:'x-grouptabs-strip x-grouptabs-tab-strip-'+this.tabPosition}});

        var beforeEl = (this.tabPosition=='bottom' ? this.stripWrap : null);
        this.strip = new Ext.Element(this.stripWrap.dom.firstChild);

		this.header.addClass('x-grouptabs-panel-header');
		this.bwrap.addClass('x-grouptabs-bwrap');
        this.body.addClass('x-tab-panel-body-'+this.tabPosition + ' x-grouptabs-panel-body');

        if (!this.itemTpl) {
            var tt = new Ext.Template(
                '<li class="{cls}" id="{id}">', 
                //'<a class="x-grouptabs-expand" onclick="return false;"></a>', 
                '',
                '<a class="x-grouptabs-text {iconCls}" href="#" onclick="return false;">',
                '<span>{text}</span></a>', 
                '</li>'
            );
            tt.disableFormats = true;
            tt.compile();
            Ext.ux.GroupTabPanel.prototype.itemTpl = tt;
        }

        this.items.each(this.initGroup, this);
    },
    
    afterRender: function(){
        Ext.ux.GroupTabPanel.superclass.afterRender.call(this);
        
        this.tabJoint = Ext.fly(this.body.dom.parentNode).createChild({
            cls: 'x-tab-joint'
        });
        
        this.addClass('x-tab-panel-' + this.tabPosition);
        this.header.setWidth(this.tabWidth);
        
        if (this.activeGroup !== undefined) {
            var group = (typeof this.activeGroup == 'object') ? this.activeGroup : this.items.get(this.activeGroup);
            delete this.activeGroup;
            this.setActiveGroup(group);
            group.setActiveTab(group.getMainItem());
        }
    },

    getGroupEl : Ext.TabPanel.prototype.getTabEl,
        
    // private
    findTargets: function(e){
        var item = null;
        var itemEl = e.getTarget('li', this.strip);
        if (itemEl) {
            item = this.findById(itemEl.id.split(this.idDelimiter)[1]);
            if (item.disabled) {
                return {
                    expand: null,
                    item: null,
                    el: null
                };
            }
        }
        return {
            expand: e.getTarget('.x-grouptabs-expand', this.strip),
            isGroup: !e.getTarget('ul.x-grouptabs-sub', this.strip),
            item: item,
            el: itemEl
        };
    },
    
    // private
    onStripMouseDown: function(e){
        if (e.button != 0) {
            return;
        }
        e.preventDefault();
        var t = this.findTargets(e);
        if (t.expand) {
            this.toggleGroup(t.el);
        }
        else if (t.item) {
            if(t.isGroup) {
                t.item.setActiveTab(t.item.getMainItem());
            }
            else {
                t.item.ownerCt.setActiveTab(t.item);
            }
        }
    },
    
    expandGroup: function(groupEl){
        if(groupEl.isXType) {
            groupEl = this.getGroupEl(groupEl);
        }
        Ext.fly(groupEl).addClass('x-grouptabs-expanded');
    },
    
    toggleGroup: function(groupEl){
        if(groupEl.isXType) {
            groupEl = this.getGroupEl(groupEl);
        }        
        Ext.fly(groupEl).toggleClass('x-grouptabs-expanded');
		this.syncTabJoint();
    },    
    
    syncTabJoint: function(groupEl){
        if (!this.tabJoint) {
            return;
        }
        
        groupEl = groupEl || this.getGroupEl(this.activeGroup);
        if(groupEl) {
            this.tabJoint.setHeight(Ext.fly(groupEl).getHeight() - 2); 
			
            var y = Ext.isGecko2 ? 0 : 1;
            if (this.tabPosition == 'left'){
                this.tabJoint.alignTo(groupEl, 'tl-tr', [-2,y]);
            }
            else {
                this.tabJoint.alignTo(groupEl, 'tr-tl', [1,y]);
            }           
        }
        else {
            this.tabJoint.hide();
        }
    },
    
    getActiveTab : function() {
        if(!this.activeGroup) return null;
        return this.activeGroup.getTabEl(this.activeGroup.activeTab) || null;  
    },
    
    onResize: function(){
        Ext.ux.GroupTabPanel.superclass.onResize.apply(this, arguments);
        this.syncTabJoint();
    },
    
    createCorner: function(el, pos){
        return Ext.fly(el).createChild({
            cls: 'x-grouptabs-corner x-grouptabs-corner-' + pos
        });
    },
    
    initGroup: function(group, index){
        var before = this.strip.dom.childNodes[index];        
        var p = this.getTemplateArgs(group);
        if (index === 0) {
            p.cls += ' x-tab-first';
        }
        p.cls += ' x-grouptabs-main';
        p.text = group.getMainItem().title;
        
        var el = before ? this.itemTpl.insertBefore(before, p) : this.itemTpl.append(this.strip, p);
        
        var tl = this.createCorner(el, 'top-' + this.tabPosition);
        var bl = this.createCorner(el, 'bottom-' + this.tabPosition);

        if (group.expanded) {
            this.expandGroup(el);
        }

        if (Ext.isIE6 || (Ext.isIE && !Ext.isStrict)){
            bl.setLeft('-10px');
            bl.setBottom('-5px');
            tl.setLeft('-10px');
            tl.setTop('-5px');
        }

        this.mon(group, 'changemainitem', this.onGroupChangeMainItem, this);
        this.mon(group, 'beforetabchange', this.onGroupBeforeTabChange, this);
    },
    
    setActiveGroup : function(group) {
        group = this.getComponent(group);
        if(!group || this.fireEvent('beforegroupchange', this, group, this.activeGroup) === false){
            return;
        }
        if(!this.rendered){
            this.activeGroup = group;
            return;
        }
        if(this.activeGroup != group){
            if(this.activeGroup){
                var oldEl = this.getGroupEl(this.activeGroup);
                if(oldEl){
                    Ext.fly(oldEl).removeClass('x-grouptabs-strip-active');
                }
                this.activeGroup.fireEvent('deactivate', this.activeTab);
            }

            var groupEl = this.getGroupEl(group);
            Ext.fly(groupEl).addClass('x-grouptabs-strip-active');
                        
            this.activeGroup = group;
            this.stack.add(group);

            this.layout.setActiveItem(group);
            this.syncTabJoint(groupEl);

            group.fireEvent('activate', group);
            this.fireEvent('groupchange', this, group);
        }        
    },
    
    onGroupBeforeTabChange: function(group, newTab, oldTab){
        if(group !== this.activeGroup || newTab !== oldTab) {
            this.strip.select('.x-grouptabs-sub > li.x-grouptabs-strip-active', true).removeClass('x-grouptabs-strip-active');
        } 
        
        this.expandGroup(this.getGroupEl(group));
        this.setActiveGroup(group);
    },
    
    getFrameHeight: function(){
        var h = this.el.getFrameWidth('tb');
        h += (this.tbar ? this.tbar.getHeight() : 0) +
        (this.bbar ? this.bbar.getHeight() : 0);
        
        return h;
    },
    
    adjustBodyWidth: function(w){
        return w - this.tabWidth;
    }
});

Ext.reg('grouptabpanel', Ext.ux.GroupTabPanel);