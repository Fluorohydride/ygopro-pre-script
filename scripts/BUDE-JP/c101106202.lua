--ヴァレルロード・R・ドラゴン
--
--Script by RukioRuler
function c101106202.initial_effect(c)
	c:EnableReviveLimit()
	--disable spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101106202,0))
	e1:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_SPSUMMON)
	e1:SetCountLimit(1,101106202)
	e1:SetCondition(c101106202.condition)
	e1:SetTarget(c101106202.target)
	e1:SetOperation(c101106202.operation)
	c:RegisterEffect(e1)
	--send to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101106202,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,101106202+100)
	e2:SetTarget(c101106202.thtg)
	e2:SetOperation(c101106202.thop)
	c:RegisterEffect(e2)
end
function c101106202.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=ep and Duel.GetCurrentChain()==0
end
function c101106202.filter(c,e)
	return c:IsFaceup() and c:IsSetCard(0x102) and c:IsType(TYPE_MONSTER)
end
function c101106202.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	local g=Duel.GetMatchingGroup(c101106202.filter,tp,LOCATION_MZONE,0,1,1,nil)
	g:AddCard(c)
	g:Merge(eg)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,eg:GetCount()+1,0,0)
end
function c101106202.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler()
	Duel.NegateSummon(eg)
	Duel.Destroy(eg,REASON_EFFECT)
	local g=Duel.GetMatchingGroup(c101106202.filter,tp,LOCATION_MZONE,0,1,1,nil)
	g:AddCard(tc)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local sg=g:Select(tp,1,1,nil)
	if sg:GetCount()>0 then
		Duel.BreakEffect()
		Duel.HintSelection(sg)
		Duel.Destroy(sg,REASON_EFFECT)
	end
end
function c101106202.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x10f,0x102) and c:IsAbleToHand()
end
function c101106202.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c101106202.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101106202.thfilter,tp,LOCATION_GRAVE,0,1,nil)
		and Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=Duel.SelectTarget(tp,c101106202.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD+LOCATION_HAND,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c101106202.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,nil)
	if #g==0 then return end
	Duel.HintSelection(g)
	if Duel.Destroy(g,REASON_EFFECT)~=0 and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
