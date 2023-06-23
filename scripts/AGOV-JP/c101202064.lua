--coded by Lyris
--Concours de Cuisine (Confectionery Contest)
local s, id, o = GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id+o)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.atktg)
	e2:SetOperation(s.atkop)
	c:RegisterEffect(e2)
end
function s.filter(c)
	return c:IsSetCard(0x196,0x29d) and c:IsType(TYPE_PENDULUM)
end
function s.sfilter(c,e,tp,p,arches)
	if not p then p=tp end
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,p) and (not arches or c:IsSetCard(table.unpack(arches)))
end
function s.chk(g,e,tp)
	if #g<2 then return false end
	local ac,bc=g:GetFirst(),g:GetNext()
	return (s.sfilter(ac,e,tp) and s.sfilter(bc,e,tp,1-tp) or s.sfilter(bc,e,tp) and s.sfilter(ac,e,tp,1-tp))
		and (ac:IsSetCard(0x196) and bc:IsSetCard(0x29d) or ac:IsSetCard(0x29d) and bc:IsSetCard(0x196))
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_DECK+LOCATION_EXTRA+LOCATION_HAND,0,1,nil)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)>0 and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and g:CheckSubGroup(s.chk,2,2,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,PLAYER_ALL,LOCATION_DECK+LOCATION_EXTRA+LOCATION_HAND)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_DECK+LOCATION_EXTRA+LOCATION_HAND,0,1,nil)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)>0
		and not Duel.IsPlayerAffectedByEffect(tp,59822133) and g:CheckSubGroup(s.chk,2,2) then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,2))
		local sc=g:FilterSelect(tp,s.sfilter,1,1,nil,e,tp,tp,{0x196,0x29d}):GetFirst()
		local arches={sc:IsSetCard(0x196) and 0x29d,sc:IsSetCard(0x29d) and 0x196}
		for i=#arches,1,-1 do if not t[i] then table.remove(t,i) end end
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,3))
		local oc=g:FilterSelect(tp,s.sfilter,1,1,sc,e,tp,1-tp,arches):GetFirst()
		Duel.SpecialSummonStep(sc,0,tp,tp,false,false,POS_FACEUP)
		Duel.SpecialSummonStep(oc,0,tp,1-tp,false,false,POS_FACEUP)
		Duel.SpecialSummonComplete()
	end
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetTargetRange(0xff,0xff)
	e1:SetTarget(aux.TargetBoolFunction(aux.NOT(Card.IsSetCard),0x196,0x29d))
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetValue(s.lim)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	Duel.RegisterEffect(e2,tp)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	Duel.RegisterEffect(e3,tp)
	local e4=e1:Clone()
	e4:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	Duel.RegisterEffect(e4,tp)
end
function s.lim(e,c)
	if not c then return false end
	return c:IsControler(e:GetHandlerPlayer())
end
function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,0x197)
		and Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(Card.IsSetCard,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,0x197)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(ct*200)
		c:RegisterEffect(e1)
	end
end
