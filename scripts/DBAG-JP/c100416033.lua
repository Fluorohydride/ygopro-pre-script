--ベアルクティ－ポラリィ

--Scripted by mallu11
function c100416033.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c100416033.sprcon)
	e2:SetOperation(c100416033.sprop)
	c:RegisterEffect(e2)
	--activate card
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100416033,0))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,100416033)
	e3:SetTarget(c100416033.acttg)
	e3:SetOperation(c100416033.actop)
	c:RegisterEffect(e3)
	--to hand/spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(100416033,1))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,100416033+100)
	e4:SetCost(c100416033.thcost)
	e4:SetTarget(c100416033.thtg)
	e4:SetOperation(c100416033.thop)
	c:RegisterEffect(e4)
end
function c100416033.tgrfilter(c)
	return c:IsFaceup() and c:IsLevelAbove(1) and c:IsAbleToGraveAsCost()
end
function c100416033.mnfilter(c,g)
	return g:IsExists(c100416033.mnfilter2,1,c,c)
end
function c100416033.mnfilter2(c,mc)
	return c:GetLevel()-mc:GetLevel()==1
end
function c100416033.fselect(g,tp,sc)
	return g:GetCount()==2 and g:IsExists(Card.IsType,1,nil,TYPE_TUNER) and g:IsExists(aux.NOT(Card.IsType),1,nil,TYPE_TUNER) and g:IsExists(c100416033.mnfilter,1,nil,g) and Duel.GetLocationCountFromEx(tp,tp,g,sc)>0
end
function c100416033.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c100416033.tgrfilter,tp,LOCATION_MZONE,0,nil)
	return g:CheckSubGroup(c100416033.fselect,2,2,tp,c)
end
function c100416033.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c100416033.tgrfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tg=g:SelectSubGroup(tp,c100416033.fselect,false,2,2,tp,c)
	Duel.SendtoGrave(tg,REASON_COST)
end
function c100416033.actfilter(c,tp)
	return c:IsCode(100416038) and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function c100416033.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100416033.actfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	if not Duel.CheckPhaseActivity() then e:SetLabel(1) else e:SetLabel(0) end
end
function c100416033.actop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	if e:GetLabel()==1 then Duel.RegisterFlagEffect(tp,15248873,RESET_CHAIN,0,1) end
	local g=Duel.SelectMatchingCard(tp,c100416033.actfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	Duel.ResetFlagEffect(tp,15248873)
	local tc=g:GetFirst()
	if tc then
		local te=tc:GetActivateEffect()
		if e:GetLabel()==1 then Duel.RegisterFlagEffect(tp,15248873,RESET_CHAIN,0,1) end
		Duel.ResetFlagEffect(tp,15248873)
		local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
		te:UseCountLimit(tp,1,true)
		local tep=tc:GetControler()
		local cost=te:GetCost()
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
	end
end
function c100416033.rfilter(c,tp)
	return c:IsLevelAbove(7) and (c:IsControler(tp) or c:IsFaceup())
end
function c100416033.rfilter2(c,e,tp)
	return Duel.IsExistingMatchingCard(c100416033.cfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,c)
end
function c100416033.cfilter(c,e,tp,mc)
	if not (c:IsSetCard(0x261) and c:IsType(TYPE_MONSTER)) then return false end
	local b1=c:IsAbleToHand()
	local b2=c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	if not b1 and b2 then
		return Duel.GetMZoneCount(tp,mc)>0
	else
		return b1 or b2
	end
end
function c100416033.excostfilter(c,tp)
	return c:IsAbleToRemove() and c:IsHasEffect(100416038,tp)
end
function c100416033.cfilter2(c,e,tp,ft)
	return Duel.IsExistingMatchingCard(c100416033.thfilter,tp,LOCATION_GRAVE,0,1,c,e,tp,ft)
end
function c100416033.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetReleaseGroup(tp):Filter(c100416033.rfilter,nil,tp)
	local g2=Duel.GetMatchingGroup(c100416033.excostfilter,tp,LOCATION_GRAVE,0,nil,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local b1=g1:IsExists(c100416033.rfilter2,1,nil,e,tp)
	local b2=g2:IsExists(c100416033.cfilter2,1,nil,e,tp,ft)
	if chk==0 then return b1 or b2 end
	local s=0
	if b1 and not b2 then
		s=0
	elseif not b1 and b2 then
		s=1
	elseif b1 and b2 then
		s=Duel.SelectOption(tp,aux.Stringid(100416033,2),aux.Stringid(100416033,3))
	end
	local tc
	if s==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		tc=g1:FilterSelect(tp,c100416033.rfilter2,1,1,nil,e,tp):GetFirst()
		Duel.Release(tc,REASON_COST)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		tc=g2:FilterSelect(tp,c100416033.cfilter2,1,1,nil,e,tp,ft):GetFirst()
		local te=tc:IsHasEffect(100416038,tp)
		if te then
			te:UseCountLimit(tp)
			Duel.Remove(tc,POS_FACEUP,REASON_EFFECT+REASON_REPLACE)
		end
	end
end
function c100416033.thfilter(c,e,tp,ft)
	return c:IsSetCard(0x261) and c:IsType(TYPE_MONSTER) and (c:IsAbleToHand() or c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (not ft or ft>0))
end
function c100416033.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100416033.thfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_GRAVE)
end
function c100416033.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c100416033.thfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local tc=g:GetFirst()
	if tc then
		if tc:IsAbleToHand() and (not tc:IsCanBeSpecialSummoned(e,0,tp,false,false) or ft<=0 or Duel.SelectOption(tp,1190,1152)==0) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
