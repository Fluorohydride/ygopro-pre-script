--征服斗魂 重型电子人
--这个卡名的①②的效果1回合各能使用1次，同一连锁上不能发动。
--①：自己·对方的主要阶段，以机械族以外的自己场上1只「征服斗魂」怪兽为对象才能发动。那只怪兽回到手卡，这张卡从手卡特殊召唤。
--②：自己·对方回合，可以从以下选择1个，把那属性的手卡的怪兽各1只给对方观看发动。
--●暗：自己从卡组抽1张。
--●地·炎：给与对方1500伤害。
function c100420018.initial_effect(c)
	--return and spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100420018,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCost(c100420018.spcost)
	e1:SetTarget(c100420018.sptg)
	e1:SetOperation(c100420018.spop)
	c:RegisterEffect(e1)
	--show dark for draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100420018,1))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,100420018+100)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c100420018.drcost)
	e2:SetTarget(c100420018.drtg)
	e2:SetOperation(c100420018.drop)
	c:RegisterEffect(e2)
	--show earth and fire for damage
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100420018,2))
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,100420018+100)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c100420018.descost)
	e3:SetTarget(c100420018.destg)
	e3:SetOperation(c100420018.desop)
	c:RegisterEffect(e3)
end
function c100420018.spfilter(c)
	return c:IsSetCard(0xfb) and c:IsFaceup() and c:IsAbleToHand() and not c:IsRace(RACE_MACHINE)
		and Duel.GetMZoneCount(tp,c,tp)>0
end
function c100420018.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c100420018.spfilter(chkc,tp) end
	local c=e:GetHandler()
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingTarget(c100420018.spfilter,tp,LOCATION_MZONE,0,1,nil,tp)
		and c:GetFlagEffect(100420018)==0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c100420018.spfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	c:RegisterFlagEffect(100420018,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c100420018.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToChain(0) and Duel.SendtoHand(tc,nil,REASON_EFFECT) and c:IsRelateToChain(0) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c100420018.drcfilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and not c:IsPublic()
end
function c100420018.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100420018.drcfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c100420018.drcfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function c100420018.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return c:GetFlagEffect(100420018)==0
		and Duel.IsPlayerCanDraw(tp,1) end
	c:RegisterFlagEffect(100420018,RESET_CHAIN,0,1)
end
function c100420018.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_EFFECT)
end
function c100420018.descfilter(c)
	return c:IsAttribute(ATTRIBUTE_EARTH+ATTRIBUTE_DARK) and not c:IsPublic()
end
function c100420018.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c100420018.descfilter,tp,LOCATION_HAND,0,nil)
	if chk==0 then return g:CheckSubGroup(aux.gfcheck,2,2,Card.IsAttribute,ATTRIBUTE_EARTH,ATTRIBUTE_DARK) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local sg=g:SelectSubGroup(tp,aux.gfcheck,false,2,2,Card.IsAttribute,ATTRIBUTE_EARTH,ATTRIBUTE_DARK)
	Duel.ConfirmCards(1-tp,sg)
	Duel.ShuffleHand(tp)
end
function c100420018.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=e:GetHandler():GetColumnGroup():Filter(Card.IsLocation,nil,LOCATION_SZONE)
	if chk==0 then return #g>0 and c:GetFlagEffect(100420018)==0 end
	c:RegisterFlagEffect(100420018,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function c100420018.desop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToChain(0) then return end
	local g=e:GetHandler():GetColumnGroup():Filter(Card.IsLocation,nil,LOCATION_SZONE)
	Duel.Destroy(g,REASON_EFFECT)
end