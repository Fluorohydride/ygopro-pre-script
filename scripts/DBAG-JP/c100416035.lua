--ベアルクティ－グラン＝シャリオ
--Bearcti - Grand Chariot
--Scripted by Kohana Sonogami
function c100416035.initial_effect(c)
	c:EnableReviveLimit()
	--special summon rule
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--spsummon condition
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c100416035.sprcon)
	e2:SetOperation(c100416035.sprop)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100416035,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetTarget(c100416035.destg)
	e3:SetOperation(c100416035.desop)
	c:RegisterEffect(e3)
	--negate
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(100416035,1))
	e4:SetCategory(CATEGORY_NEGATE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c100416035.negcon)
	e4:SetCost(c100416035.negcost)
	e4:SetTarget(c100416035.negtg)
	e4:SetOperation(c100416035.negop)
	c:RegisterEffect(e4)
end
function c100416035.tgrfilter(c)
	return c:IsFaceup() and c:IsLevelAbove(1) and c:IsAbleToGraveAsCost()
end
function c100416035.tgrfilter1(c)
	return c:IsType(TYPE_TUNER) and c:IsLevelAbove(8)
end
function c100416035.tgrfilter2(c)
	return not c:IsType(TYPE_TUNER) and c:IsType(TYPE_SYNCHRO)
end
function c100416035.mnfilter(c,g)
	return g:IsExists(c100416035.mnfilter2,1,c,c)
end
function c100416035.mnfilter2(c,mc)
	return c:GetLevel()-mc:GetLevel()==7
end
function c100416035.fselect(g,tp,sc)
	return g:GetCount()==2 and g:IsExists(c100416035.tgrfilter1,1,nil) and g:IsExists(c100416035.tgrfilter2,1,nil) and g:IsExists(c100416035.mnfilter,1,nil,g) and Duel.GetLocationCountFromEx(tp,tp,g,sc)>0
end
function c100416035.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c100416035.tgrfilter,tp,LOCATION_MZONE,0,nil)
	return g:CheckSubGroup(c100416035.fselect,2,2,tp,c)
end
function c100416035.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c100416035.tgrfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tg=g:SelectSubGroup(tp,c100416035.fselect,false,2,2,tp,c)
	Duel.SendtoGrave(tg,REASON_COST)
end
function c100416035.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local dg=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,2,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,dg:GetCount(),0,0)
end
function c100416035.desop(e,tp,eg,ep,ev,re,r,rp)
	local dg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #dg>0 then
		Duel.Destroy(dg,REASON_EFFECT)
	end
end
function c100416035.negfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x261) and c:IsOnField() and c:IsControler(tp)
end
function c100416035.negcon(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return tg and tg:IsExists(c100416035.negfilter,1,nil,tp) and Duel.IsChainNegatable(ev)
end
function c100416035.costfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and (c:IsControler(tp) or c:IsFaceup())
end
function c100416035.excostfilter(c,tp)
	return c:IsAbleToRemove() and (c:IsHasEffect(100416036,tp) or c:IsHasEffect(100416038,tp))
end
function c100416035.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetReleaseGroup(tp,true):Filter(c100416035.costfilter,nil,tp)
	local g2=Duel.GetMatchingGroup(c100416035.excostfilter,tp,LOCATION_GRAVE,0,nil,tp)
	g1:Merge(g2)
	if chk==0 then return #g1>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local rg=g1:Select(tp,1,1,nil)
	local tc=rg:GetFirst()
	local te=tc:IsHasEffect(100416036,tp) or tc:IsHasEffect(100416038,tp)
	if te then
		te:UseCountLimit(tp)
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT+REASON_REPLACE)
	else
		aux.UseExtraReleaseCount(rg,tp)
		Duel.Release(tc,REASON_COST)
	end
end
function c100416035.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c100416035.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
end
